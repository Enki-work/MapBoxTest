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
            titleOutPut.selectedGroup.asObservable().do(afterNext: { (_) in
                titleBtn.sizeToFit()
            }).map({ $0.title })
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
            guard let self = self else { return }
            MapViewNavigator(with: self).showGroups()
        }.disposed(by: disposeBag)
        self.navigationItem.titleView = titleBtn
    }

    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?
            .instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController?.statusBarEndAlpha = 0
    }

    func setPointAnnotation(locations: [Location]) {
        var annotations: [LocationPointAnnotation] = []
        for location in locations {
            let annotation = LocationPointAnnotation()
            annotation.title = location.userName ?? "Unknow User"
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                           longitude: location.longitude)
            annotations.append(annotation)
        }
        if let oldAnnotations = mapView.annotations?.filter({ $0 is LocationPointAnnotation }) {
            mapView.removeAnnotations(oldAnnotations)
        }
        mapView.addAnnotations(annotations)
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

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return annotation.responds(to: #selector(getter: MGLAnnotation.title))
            && annotation is LocationPointAnnotation
    }

    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        // Instantiate and return our custom callout view.
        return LocationCalloutView(representedObject: annotation)
    }

    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // Optionally handle taps on the callout.
        print("Tapped the callout for: \(annotation)")

        // Hide the callout.
        mapView.deselectAnnotation(annotation, animated: true)
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {

        if annotation is LocationPointAnnotation {
            let reuseIdentifier = "reusableDotView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            if annotationView == nil {
                annotationView = LocationAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
                annotationView?.layer.borderWidth = 4.0
                annotationView?.layer.borderColor = UIColor.white.cgColor
                annotationView!.backgroundColor = UIColor(red: 0.03, green: 0.80, blue: 0.69, alpha: 1.0)
            }

            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        return nil
    }
}
