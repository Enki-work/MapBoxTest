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

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: MGLMapView!
    
    private lazy var checkLoginViewModel: CheckLoginViewModel = {
        return CheckLoginViewModel(with: AuthModel(),
        and: MapViewNavigator(with: self))
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
        mapView.userTrackingMode = .followWithHeading
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }
    
    func bindViewModel() {
        let checkTrigger = Observable<Void>.just(())
        let input = CheckLoginViewModel.Input.init(checkTrigger: checkTrigger.asObservable().asDriverOnErrorJustComplete())
        
        checkLoginViewModel.transform(input: input).check.drive().disposed(by: disposeBag)
    }
    
    @IBAction func clickGetLocationBtn(_ sender: Any) {
        print("###############\(String(describing: mapView.userLocation?.coordinate))")
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        print("🍎############### regionWillChangeAnimated")
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        
        print("🍏############### regionWillChangeAnimated reason\(reason)")
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        
        print("🍐############### didUpdate userLocation\(String(describing: userLocation))")
    }
    
    func mapView(_ mapView: MGLMapView, didFailToLocateUserWithError error: Error) {
        print("🍌############### didFailToLocateUserWithError error\(error)")
    }
}
