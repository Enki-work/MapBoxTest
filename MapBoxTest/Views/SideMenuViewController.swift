//
//  SideMenuViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/27.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift

class SideMenuViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let cellTitleList = Observable.just(["マイローケーション",
                                         "マイグループ",
                                         "マイグループローケーション"])

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    private func setTableView() {
        tableView.tableFooterView = UIView.init()
        cellTitleList
            .bind(to: tableView.rx.items) { (tableView, _, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuListItem")!
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)

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
                default:
                    break
                }
            }

        }).disposed(by: disposeBag)
    }
}
