//
//  LoginViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {

    struct Input {
        let loginTrigger: Driver<Void>
        let signupTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }

    struct Output {
        let login: Driver<UserModel>
        let signup: Driver<Void>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let authModel: AuthModel
    private let navigator: LoginNavigator
    private let signupNavigator: SignupNavigator

    init(with authModel: AuthModel,
         and navigator: LoginNavigator,
         and signupNavigator: SignupNavigator) {
        self.authModel = authModel
        self.navigator = navigator
        self.signupNavigator = signupNavigator
    }

    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        let state = State()
        let requiredInputs = Driver.combineLatest(input.email, input.password)
        let login = input.loginTrigger
            .withLatestFrom(requiredInputs)
            .flatMapLatest { [unowned self] (email: String, password: String) in
                return self.authModel.login(with: email, and: password)
                    .do(onNext: { [unowned self] user in
                        if user.mail.count > 0, user.pwd.count > 0 {
                            self.navigator.toMap()
                        }
                    })
                    .trackError(state.error)
                    .asDriverOnErrorJustComplete()
        }
        let signup = input.signupTrigger.do(onNext: {
            self.signupNavigator.toSignupView()
        }).asDriver()

        return LoginViewModel.Output(login: login,
                                     signup: signup,
                                     error: state.error.asDriver())
    }
}
