//
//  LocationsViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/28.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift

class MyLocationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Variables

    private lazy var loginViewModel: LoginViewModel = {
        return LoginViewModel(with: AuthModel(),
                              and: LoginNavigator(with: self))
    }()

    // MARK: - Constants

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    private func setTableView() {
        tableView.tableFooterView = UIView.init()
        cellTitleList
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuListIatem")!
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
                SideMenuNavigator.init(with: mapVC).toLocations()
            }

        }).disposed(by: disposeBag)
    }
}