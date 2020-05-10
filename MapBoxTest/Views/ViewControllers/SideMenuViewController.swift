//
//  SideMenuViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/27.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SideMenuViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    private var logoutViewModel: LogoutViewModel?
    let cellTitleList = Observable.just(["マイローケーション",
                                         "グループ管理",
                                         "マイグループローケーション",
                                         "ログアウト"])

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    private func setTableView() {
        defaultDisposeBag = DisposeBag()
        tableView.tableFooterView = UIView.init()
        cellTitleList
            .bind(to: tableView.rx.items) { (tableView, _, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuListItem")!
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: defaultDisposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self,
                let naviVC = self.presentingViewController as? UINavigationController,
                let mapVC = naviVC.topViewController as? MapViewController else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) {
                switch indexPath.row {
                case 0:
                    SideMenuNavigator.init(with: mapVC).toLocations()

                case 1:
                    SideMenuNavigator.init(with: mapVC).toGroups()

                case 2:
                    SideMenuNavigator.init(with: mapVC).toGroupLocations()

                case 3:
                    if self.logoutViewModel == nil {
                        self.logoutViewModel = LogoutViewModel(with: AuthModel(),
                                                               and: LogoutNavigator(with: mapVC))
                    }
                    let logoutTrigger = Driver<Void>.just(())
                    let input = LogoutViewModel.Input.init(logoutTrigger: logoutTrigger)
                    let output = self.logoutViewModel?.transform(input: input)
                    output?.logout.drive().disposed(by: self.defaultDisposeBag)
                default:
                    break
                }
            }

        }).disposed(by: defaultDisposeBag)
    }
}
