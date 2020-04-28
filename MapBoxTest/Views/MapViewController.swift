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

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setupMenu()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }

    func bindViewModel() {
        let checkTrigger = Observable<Void>.just(())
        let input = CheckLoginViewModel.Input.init(checkTrigger:
            checkTrigger.asObservable().asDriverOnErrorJustComplete())

        checkLoginViewModel.transform(input: input).check.drive().disposed(by: disposeBag)
    }
    
    private func setupMenu() {
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
        mapView.userTrackingMode = .followWithHeading
        mapView.attributionButtonPosition = .bottomLeft
    }

    private func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?
            .instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController

        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.leftMenuNavigationController?.statusBarEndAlpha = 0
    }

    @IBAction func clickLeftBarItem(_ sender: UIBarButtonItem) {
        MapViewNavigator(with: self).toSideMenu()
    }

    @IBAction func clickCurrentBtn(_ sender: Any) {
        guard let currentLocation = mapView.userLocation?.coordinate else {
            return
        }
        mapView.setCenter(currentLocation, animated: true)
        mapView.userTrackingMode = .followWithHeading
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
