//
//  JoinGroupViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/10.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class JoinGroupViewModel: ViewModelType {

    struct Input {
        let groupIdBeginTrigger: Driver<SimpleGroupInfoProtocol>
    }

    struct Output {
        let result: Driver<Void>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let userGroupModel: UserGroupModel
    private let navigator: AllGroupViewNavigator

    init(with userGroupModel: UserGroupModel,
         navigator: AllGroupViewNavigator) {
        self.userGroupModel = userGroupModel
        self.navigator = navigator
    }

    func transform(input: JoinGroupViewModel.Input) -> JoinGroupViewModel.Output {
        let state = State()
        let result = input.groupIdBeginTrigger.flatMapLatest { [unowned self] group in
            return self.userGroupModel.joinUserGroups(groupId: group.id)
                .do(afterNext: { [weak self](_) in
                    self?.navigator.toGroupManageView()
                })
                .trackError(state.error)
                .asDriverOnSkipError()
        }
        return JoinGroupViewModel.Output(result: result, error: state.error.asDriver())
    }
}
