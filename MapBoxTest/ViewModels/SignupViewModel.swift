//
//  SignupViewModel.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/20.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// 検証結果
enum ValidationResult {
    case success(message: String)
    case empty
    case validating
    case failed(message: String)
}

class SignupViewModel: ViewModelType {
    struct Input {
        let signupTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
        let repeatedPassword: Driver<String>
    }

    struct Output {
        let validatedEmail: Driver<ValidationResult>
        let validatedPassword: Driver<ValidationResult>
        let validatedPasswordRepeated: Driver<ValidationResult>
        let signupEnabled: Driver<Bool>
    }

    struct State {
        let error = ErrorTracker()
    }

    func transform(input: SignupViewModel.Input) -> SignupViewModel.Output {
        let validationService = MBDefaultValidationService()

        let validatedEmail = input.email.flatMapLatest { email in
            return validationService.validateEmail(email)
                .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
        }

        let validatedPassword = input.password.map { password in
            return validationService.validatePassword(password)
        }

        let validateRepeatedPassword = Driver.combineLatest(input.password, input.repeatedPassword) {
            validationService.validateRepeatedPassword($0, repeatedPassword: $1)
        }

        let signupEnabled = Driver
            .combineLatest(validatedEmail,
                           validatedPassword,
                           validateRepeatedPassword) { (email, password, repeatedPassword) in
                email.isValid && password.isValid && repeatedPassword.isValid
            }.distinctUntilChanged()

        return SignupViewModel.Output(validatedEmail: validatedEmail,
                                      validatedPassword: validatedPassword,
                                      validatedPasswordRepeated: validateRepeatedPassword,
                                      signupEnabled: signupEnabled)
    }
}

extension ValidationResult {
    /// 検証済みかどうか
    var isValid: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
}
