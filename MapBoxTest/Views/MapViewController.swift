//
//  MapViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/13.

//  Copyright © 2020 MapBoxTest. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
        mapView.userTrackingMode = .followWithHeading
    }

    @IBAction func clickGetLocationBtn(_ sender: Any) {
        
        print("###############\(String(describing: mapView.userLocation?.coordinate))")
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
