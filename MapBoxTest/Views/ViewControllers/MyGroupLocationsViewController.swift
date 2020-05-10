//
//  File.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/01.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyGroupLocationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Variables

    private lazy var locationViewModel: GetGroupLocationsViewModel = {
        return GetGroupLocationsViewModel(with: LocationModel())
    }()

    // MARK: - Constants

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        defaultDisposeBag = DisposeBag()
        let checkTrigger = Driver<Void>.just(())
        let input = GetGroupLocationsViewModel.Input(checkTrigger: checkTrigger)
        let output = locationViewModel.transform(input: input)

        setTableView(locations: output.locations.asObservable())
        output.error.drive(onNext: presentErrorAlert).disposed(by: defaultDisposeBag)
    }

    private func setTableView(locations: Observable<[Location]>) {
        tableView.tableFooterView = UIView.init()
        locations
            .bind(to: tableView.rx.items) { (tableView, _, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupLocationsListItem")!
                cell.textLabel?.text = "latitude: \(element.latitude) longitude:\(element.longitude)"
                return cell
            }
            .disposed(by: defaultDisposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self,
                let naviVC = self.presentingViewController as? UINavigationController,
                let mapVC = naviVC.topViewController as? MapViewController else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) {
                SideMenuNavigator.init(with: mapVC).toLocations()
            }

        }).disposed(by: defaultDisposeBag)
    }
}
