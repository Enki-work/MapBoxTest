//
//  MapViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/13.

//  Copyright © 2020 MapBoxTest. All rights reserved.
//

import UIKit
import Mapbox
import RxSwift
import RxCocoa
import SideMenu

class MapViewController: BaseViewController {

    @IBOutlet private weak var mapView: MGLMapView!

    private lazy var checkLoginViewModel: CheckLoginViewModel = {
        return CheckLoginViewModel(with: AuthModel(),
                                   and: MapViewNavigator(with: self))
    }()

    private lazy var mapViewTitleViewModel: MapViewTitleViewModel = {
        return MapViewTitleViewModel(with: GroupModel.init())
    }()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setupMap()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }

    func bindViewModel() {
        let beginTrigger = Driver<Void>.just(())
        let checkLoginInput = CheckLoginViewModel.Input.init(checkTrigger:
            beginTrigger)
        checkLoginViewModel.transform(input: checkLoginInput).check.drive().disposed(by: disposeBag)

        let titleInput = MapViewTitleViewModel.Input.init(beginTrigger: beginTrigger)
        let titleOutPut = mapViewTitleViewModel.transform(input: titleInput)
        if let titleBtn = self.navigationItem.titleView as? UIButton {
            titleOutPut.selectedGroupTitle.asObservable().do(afterNext: { (_) in
                titleBtn.sizeToFit()
            })
                .bind(to: titleBtn.rx.title()).disposed(by: disposeBag)
        }
    }

    private func setupMap() {
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
        mapView.userTrackingMode = .followWithHeading
        mapView.attributionButtonPosition = .bottomLeft
    }

    private func setupUI() {
        let titleBtn = UIButton(type: .custom)
        titleBtn.setTitleColor(UIColor.init(named: "menuColor"), for: .normal)
        titleBtn.rx.tap.bind { [weak self]() in

        }.disposed(by: disposeBag)
        self.navigationItem.titleView = titleBtn
    }

    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?
            .instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController?.statusBarEndAlpha = 0
    }

    @IBAction func clickLeftBarItem(_ sender: UIBarButtonItem) {
        MapViewNavigator(with: self).toSideMenu()
    }

    @IBAction func clickCurrentBtn(_ sender: Any) {
        guard let currentLocation = mapView.userLocation?.coordinate else {
            return
        }
        mapView.setCenter(currentLocation,
                          zoomLevel: mapView.zoomLevel,
                          direction: mapView.direction,
                          animated: true, completionHandler: { [weak self] in
                              self?.mapView.userTrackingMode = .followWithHeading
                          })
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        print("🍎############### regionWillChangeAnimated")
    }

    func mapView(_ mapView: MGLMapView,
                 regionWillChangeWith reason: MGLCameraChangeReason,
                 animated: Bool) {

        print("🍏############### regionWillChangeAnimated reason\(reason)")
    }

    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {

        print("🍐############### didUpdate userLocation\(String(describing: userLocation))")
    }

    func mapView(_ mapView: MGLMapView, didFailToLocateUserWithError error: Error) {
        print("🍌############### didFailToLocateUserWithError error\(error)")
    }
}
