//
//  CheckLoginViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/16.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CheckLoginViewModel: ViewModelType {
    
    struct Input {
        let checkTrigger: Driver<Void>
    }
    
    struct Output {
        let check: Driver<Bool>
        let error: Driver<Error>
    }
    
    struct State {
        let error = ErrorTracker()
    }
    
    private let authModel: AuthModel
    private let navigator: MapViewNavigator
    
    init(with authModel: AuthModel, and navigator: MapViewNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }
    
    func transform(input: CheckLoginViewModel.Input) -> CheckLoginViewModel.Output {
        let state = State()
        let check: Driver<Bool> = input.checkTrigger
            .flatMapLatest { [unowned self]  in
                return self.authModel.checkLogin()
                .map { [weak self] isLogin in
                    if !isLogin {
                        self?.navigator.toLogin()
                    }
                    return isLogin
                }.trackError(state.error)
                .asDriverOnErrorJustComplete()
        }
        return CheckLoginViewModel.Output(check: check, error: state.error.asDriver())
    }
}
