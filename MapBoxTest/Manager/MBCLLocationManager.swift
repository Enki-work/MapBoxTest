//
//  MBCLLocationManager.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/16.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import CoreLocation

final class MBCLLocationManager: NSObject {
    
    // MARK: - Constants
    
    private let clLocationManager: CLLocationManager = CLLocationManager()
    
    // MARK: - Variables
    
    static var shared: MBCLLocationManager = MBCLLocationManager()
    var delegate: MBCLLocationManagerDelegate?
    
    // MARK: - Methods
    
    /// 初期化
    private override init() {
        super.init()
        clLocationManager.delegate = self
    }
    
    /// 位置情報の取得を開始する
    func startRequestLocation() {
        clLocationManager.allowsBackgroundLocationUpdates = true
        // 位置情報の取得を開始する
        clLocationManager.startUpdatingLocation()
        // 位置情報の取得を維持するように
        clLocationManager.startMonitoringSignificantLocationChanges()
    }
    
    /// 位置情報の更新を開始するメソッド
    func startUpdatingLocation() {
        clLocationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate Methods

extension MBCLLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // デバッグモードでローカル通知を送付する
        #if DEBUG
        var lat = ""
        var lon = ""
        
        if let myLocations = locations.first {
            lat = String(format: "%.2f", myLocations.coordinate.latitude)
            lon = String(format: "%.2f", myLocations.coordinate.longitude)
        }
        LocalNotificationManager.sendLocalNotification(title: "位置情報の更新を開始します",
                                                       body: "あなた現在の位置情報 - 緯度: " + lat + ", 経度: " + lon,
                                                       timeInterval: 5,
                                                       isRepeats: false,
                                                       identifier: "didUpdateLocationsIdentifier") {
                                                        (error) in
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "")
                                                        }
        }
        #endif
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            // 一回限り・使用中のみ許可の場合
            clLocationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            // 常に許可の場合
            self.startRequestLocation()
        case .notDetermined:
            break
        case .restricted:
            break
        default:
            break
        }
    }
}

// MARK: - MBCLLocationManagerDelegate Methods
extension MBCLLocationManager: MBCLLocationManagerDelegate {
    
}
