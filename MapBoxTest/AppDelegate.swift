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

    /// 位置情報を管理するマネージャー
    private var locationManager: MBCLLocationManager = MBCLLocationManager.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                         [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        locationManager.startRequestLocation()
        requestLocalNotificationAuth()

        if let _ = launchOptions?[UIApplication.LaunchOptionsKey.location] {
            // 位置情報の更新を開始する
            locationManager.startUpdatingLocation()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    private func requestLocalNotificationAuth() {
        var options: UNAuthorizationOptions

        // iOS12以降の場合お試しプッシュ通知を送る
        if #available(iOS 12.0, *) {
            options = [.alert, .sound, .badge, .provisional]
        } else {
            options = [.alert, .sound, .badge]
        }

        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (isAcceped, error) in

            guard error == nil else {
                print(error?.localizedDescription ?? "Unknown Error")
                return
            }

            if isAcceped {
                // 同意された場合
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                // 拒否された場合
                print("ローカル通知は拒否された")
            }
        }
    }
}
