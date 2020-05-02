//
//  Constant.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/28.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation

enum MBTUrlString {
    //ローカルのloginURL
    static let hostUrlString = "http://192.168.0.3:8081"
    static let loginUrlString = "/api/users/login"
    static let registerUrlString = "/api/users/register"
    static let getUserLocationUrlString = "/api/locations/user"
    static let getGroupLocationUrlString = "/api/locations/userGroup"
    static let getUserGroupUrlString = "/api/groups"
}

extension Dictionary where Key == String, Value == String {
    func getUrlParams() -> String {
        self.enumerated().reduce("") { (result, element) -> String in
            if result.isEmpty {
                return "?\(element.element.key)=\(element.element.value)"
            } else {
                return result + "&\(element.element.key)=\(element.element.value)"
            }
        }
    }
}
