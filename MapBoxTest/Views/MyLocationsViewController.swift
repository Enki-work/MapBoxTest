//
//  LocationsViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/28.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyLocationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Variables

    private lazy var locationViewModel: GetUserLocationsViewModel = {
        return GetUserLocationsViewModel(with: LocationModel())
    }()

    // MARK: - Constants

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        let checkTrigger = Driver<Void>.just(())
        let input = GetUserLocationsViewModel.Input(checkTrigger: checkTrigger)
        let output = locationViewModel.transform(input: input)

        setTableView(locations: output.locations.asObservable())
        output.error.drive(onNext: presentErrorAlert).disposed(by: disposeBag)
    }

    private func setTableView(locations: Observable<[Location]>) {
        tableView.tableFooterView = UIView.init()
        locations
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsListItem")!
                cell.textLabel?.text = "latitude: \(element.latitude) longitude:\(element.longitude)"
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
