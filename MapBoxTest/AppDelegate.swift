//
//  AppDelegate.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/13.
//  Copyright © 2020 MapBoxTest. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var locationManager: CLLocationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startRequestLocation()
        requestLocalNotificationAuth()
        
        locationManager.delegate = self
        
        if let _ = launchOptions?[UIApplication.LaunchOptionsKey.location] {
            // 位置情報の取得を開始する
            locationManager.startUpdatingLocation()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func startRequestLocation() {
        
        locationManager.allowsBackgroundLocationUpdates = true
        // 位置情報の取得を開始する
        locationManager.startUpdatingLocation()
        // 位置情報の取得を維持するように
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    private func requestLocalNotificationAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,
                                                                          .sound,
                                                                          .badge])
        { (acceped, error) in
            if !acceped {
                print("ローカル通知は拒否された")
            }
        }
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lat = ""
        var lon = ""
        
        if let myLocations = locations.first {
            lat = String(format: "%.2f", myLocations.coordinate.latitude)
            lon = String(format: "%.2f", myLocations.coordinate.longitude)
        }
        LocalNotificationManager.sendLocalNotification(title: "位置情報の更新を開始します",
                                                       body: "あなた現在の位置情報 - lat: " + lat + ",lon: " + lon,
                                                       timeInterval: 5,
                                                       isRepeats: false,
                                                       identifier: "didUpdateLocationsIdentifier") {
                                                        (error) in
                                                        if error != nil {
                                                            print(error?.localizedDescription ?? "")
                                                        }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            startRequestLocation()
            break
        case .notDetermined:
            break
        case .restricted:
            break
        default:
            break
        }
    }
}
