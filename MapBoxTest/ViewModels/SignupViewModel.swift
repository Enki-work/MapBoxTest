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

class SignupViewModel: ViewModelType {
    struct Input {
        let signupFinishTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
        let repeatedPassword: Driver<String>
    }

    struct Output {
        let validatedEmail: Driver<ValidationResult>
        let validatedPassword: Driver<ValidationResult>
        let validatedPasswordRepeated: Driver<ValidationResult>
        let signupFinish: Driver<UserModel>
        let back: Driver<Void>
        let signupEnabled: Driver<Bool>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let navigator: SignupNavigator
    private let authModel: AuthModel

    init(with authModel: AuthModel, and navigator: SignupNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }

    func transform(input: SignupViewModel.Input) -> SignupViewModel.Output {
        let state = State()
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

        let requiredInputs = Driver.combineLatest(input.email, input.password)
        let signupFinish = input.signupFinishTrigger
            .withLatestFrom(requiredInputs)
            .flatMapLatest { [unowned self] (email: String, password: String) in
                return self.authModel.register(with: UserModel.init(mailAddress: email, passWord: password))
                    .do(onNext: { [unowned self] _ in
                        self.navigator.dismiss()
                    })
                    .trackError(state.error)
                    .asDriverOnErrorJustComplete()
        }

        let back = input.backTrigger.do(onNext: {
            self.navigator.dismiss()
        }).asDriver()

        return SignupViewModel.Output(validatedEmail: validatedEmail,
                                      validatedPassword: validatedPassword,
                                      validatedPasswordRepeated: validateRepeatedPassword,
                                      signupFinish: signupFinish,
                                      back: back,
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
