//
//  AllGroupViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/09.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AllGroupViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Variables

    private lazy var groupViewModel: GetAllGroupViewModel = {
        return GetAllGroupViewModel(with: GroupModel())
    }()

    private lazy var joinGroupViewModel: JoinGroupViewModel = {
        return JoinGroupViewModel(with: UserGroupModel.init(),
                                  navigator: AllGroupViewNavigator.init(with: self))
    }()

    // MARK: - Constants

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()
        let checkTrigger = Driver<Void>.just(())
        let input = GetAllGroupViewModel.Input(checkTrigger: checkTrigger)
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

        let joinUserGroupInput = JoinGroupViewModel.Input.init(groupIdBeginTrigger:
            tableView.rx.modelSelected(SimpleGroupInfoProtocol.self).asDriver())
        let joinUserGroupOutput = joinGroupViewModel.transform(input: joinUserGroupInput)
        joinUserGroupOutput.result.drive(onNext: { [weak self](_) in
            print(self?.presentingViewController)
            if let self = self, let naviVC = self.presentingViewController as? UINavigationController,
                let groupManageVC = naviVC.topViewController as? GroupManageViewController{
                groupManageVC.reloadTableViewData()
            }
        }).disposed(by: disposeBag)
        joinUserGroupOutput.error.drive(onNext: presentErrorAlert).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }
}
