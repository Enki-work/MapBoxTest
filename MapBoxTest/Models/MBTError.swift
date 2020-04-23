//
//  MBTError.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/22.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation

struct MBTError: Codable, Error {
    var errorCode: UInt
    var message: String
}
