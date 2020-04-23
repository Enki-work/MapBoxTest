//
//  MBValidationServiceProtocol.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/21.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift

// 検証結果
enum ValidationResult {
    case success(message: String)
    case empty
    case validating
    case failed(message: String)
}

protocol MBValidationServiceProtocol {
    func validateEmail(_ email: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}
