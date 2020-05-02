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

    init(mailAddress: String, passWord: String) {
        self.mailAddress = mailAddress
        self.passWord = passWord
        self.token = ""
    }

    init(token: String) {
        self.mailAddress = ""
        self.passWord = ""
        self.token = token
    }
}
