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
        let mailaddress: Driver<String>
        let password: Driver<String>
    }

    struct Output {
        let login: Driver<UserModel>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let authModel: AuthModel
    private let navigator: LoginNavigator

    init(with authModel: AuthModel, and navigator: LoginNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }

    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        let state = State()
        let requiredInputs = Driver.combineLatest(input.mailaddress, input.password)
        let login = input.loginTrigger
            .withLatestFrom(requiredInputs)
            .flatMapLatest { [unowned self] (mailaddress: String, password: String) in
                return self.authModel.login(with: UserModel.init(mailAddress: mailaddress, passWord: password))
                    .do(onNext: { [unowned self] user in
                        if user.mailAddress.count > 0, user.passWord.count > 0 {
                            self.navigator.toMap()
                        }
                    })
                    .trackError(state.error)
                    .asDriverOnErrorJustComplete()
        }
        return LoginViewModel.Output(login: login, error: state.error.asDriver())
    }
}
