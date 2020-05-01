//
//  LogoutViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/01.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LogoutViewModel: ViewModelType {

    struct Input {
        let logoutTrigger: Driver<Void>
    }

    struct Output {
        let logout: Driver<Bool>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let authModel: AuthModel
    private let navigator: LogoutNavigator

    init(with authModel: AuthModel,
         and navigator: LogoutNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }

    func transform(input: LogoutViewModel.Input) -> LogoutViewModel.Output {
        let state = State()
        let logout = input.logoutTrigger
            .flatMapLatest {
                return self.authModel.logout()
                    .do(onNext: { [weak self](result) in
                        if result {
                            UserDefaults.standard.set(nil, forKey: "myUserData")
                            self?.navigator.toLogin()
                        }
                    })
                .trackError(state.error)
                .asDriverOnSkipError()
        }

        return LogoutViewModel.Output(logout: logout,
                                      error: state.error.asDriver())
    }
}
