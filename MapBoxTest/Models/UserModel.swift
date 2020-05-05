//
//  UserModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    var mailAddress: String
    var passWord: String
    var token: String
    var isAdmin: Bool

    init(mailAddress: String, passWord: String, isAdmin: Bool = false) {
        self.mailAddress = mailAddress
        self.passWord = passWord
        self.token = ""
        self.isAdmin = isAdmin
    }

    init(token: String) {
        self.mailAddress = ""
        self.passWord = ""
        self.token = token
        isAdmin = false
    }
}
