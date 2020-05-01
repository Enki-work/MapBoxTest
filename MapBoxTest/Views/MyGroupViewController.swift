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

    private lazy var groupViewModel: GetUserGroupsViewModel = {
        return GetUserGroupsViewModel(with: GroupModel())
    }()

    // MARK: - Constants

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        let checkTrigger = Driver<Void>.just(())
        let input = GetUserGroupsViewModel.Input(checkTrigger: checkTrigger)
        let output = groupViewModel.transform(input: input)

        setTableView(groups: output.groups.asObservable())
        output.error.drive(onNext: presentErrorAlert).disposed(by: disposeBag)
    }

    private func setTableView(groups: Observable<[Group]>) {
        tableView.tableFooterView = UIView.init()
        groups
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsListItem")!
                cell.textLabel?.text = "\(element.title)"
                return cell
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self,
                let naviVC = self.presentingViewController as? UINavigationController,
                let mapVC = naviVC.topViewController as? MapViewController else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) {
                SideMenuNavigator.init(with: mapVC).toGroups()
            }

        }).disposed(by: disposeBag)
    }
}
