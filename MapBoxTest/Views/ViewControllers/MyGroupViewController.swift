//
//  MyGroupViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/29.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyGroupViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Variables

    private lazy var groupViewModel: GetGroupsViewModel = {
        return GetGroupsViewModel(with: GroupModel())
    }()

    private lazy var selectGroupViewModel: SelectGroupViewModel = {
        return SelectGroupViewModel(with: LocationModel.init(),
                                    navigator: MyGroupViewNavigator.init(with: self))
    }()

    // MARK: - Constants

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        let checkTrigger = Driver<Void>.just(())
        let input = GetGroupsViewModel.Input(checkTrigger: checkTrigger)
        let output = groupViewModel.transform(input: input)

        setTableView(groups: output.groups.asObservable())
        output.error.drive(onNext: presentErrorAlert).disposed(by: disposeBag)
    }

    private func setTableView(groups: Observable<[Group]>) {
        tableView.tableFooterView = UIView.init()
        groups
            .bind(to: tableView.rx.items) { (tableView, _, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsListItem")!
                cell.textLabel?.text = "\(element.title)"
                return cell
            }
            .disposed(by: disposeBag)

        let selectGroupInput = SelectGroupViewModel.Input.init(groupIdBeginTrigger:
            tableView.rx.modelSelected(SimpleGroupInfoProtocol.self).asDriver())
        let selectGroupOutput = selectGroupViewModel.transform(input: selectGroupInput)
        selectGroupOutput.locations.drive(onNext: { [weak self](combineData) in
            if let self = self, let naviVC = self.presentingViewController as? UINavigationController,
                let mapVC = naviVC.topViewController as? MapViewController,
                let titleBtn = mapVC.navigationItem.titleView as? UIButton {
                titleBtn.setTitle(combineData.0.title, for: .normal)
                titleBtn.sizeToFit()
                mapVC.setPointAnnotation(locations: combineData.1)
            }
        }).disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }
}
