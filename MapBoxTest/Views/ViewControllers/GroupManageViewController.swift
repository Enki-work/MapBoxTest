//
//  GroupManageViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/07.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GroupManageViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Variables

    private lazy var groupViewModel: GetGroupsViewModel = {
        return GetGroupsViewModel(with: GroupModel(), isSelectMode: false)
    }()

    private lazy var selectGroupViewModel: SelectGroupViewModel = {
        return SelectGroupViewModel(with: LocationModel.init(),
                                    navigator: MyGroupViewNavigator.init(with: self))
    }()

    private lazy var quitGroupViewModel: QuitGroupViewModel = {
        return QuitGroupViewModel(with: UserGroupModel())
    }()

    // MARK: - Constants

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        self.navigationItem.title = "グループ管理"
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()
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

        tableView.rx.modelDeleted(Group.self).subscribe(onNext: { [weak self](group) in
            guard let self = self else { return }
            let groupIdBeginTrigger = Driver<SimpleGroupInfoProtocol>.just(group)
            let input = QuitGroupViewModel.Input(groupIdBeginTrigger: groupIdBeginTrigger)
            let output = self.quitGroupViewModel.transform(input: input)
            output.result.drive(onNext: { [weak self](_) in
                self?.bindViewModel()
            }).disposed(by: self.disposeBag)
            output.error.drive(onNext: self.presentErrorAlert)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    @IBAction func clickJoinBtn(_ sender: Any) {
        GroupManageNavigator.init(with: self).showAllGroups()
    }

    func reloadTableViewData() {
        self.bindViewModel()
    }
}

extension GroupManageViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            .none
    }
}
