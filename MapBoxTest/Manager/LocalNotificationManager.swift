//
//  LocalNotificationManager.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {

    // ローカル通知を設定する
    class func sendLocalNotification(contents: (title: String?, body: String?),
                                     timeInterval: TimeInterval,
                                     isRepeats: Bool,
                                     identifier: String,
                                     completionHandler: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        if let title = contents.title {
            content.title = title
        }

        if let body = contents.body {
            content.body = body
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                        repeats: isRepeats)

        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: completionHandler)
    }
}
