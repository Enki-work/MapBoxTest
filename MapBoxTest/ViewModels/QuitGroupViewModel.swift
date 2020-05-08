//
//  QuitGroupViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/07.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class QuitGroupViewModel: ViewModelType {

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

    init(with userGroupModel: UserGroupModel) {
        self.userGroupModel = userGroupModel
    }

    func transform(input: QuitGroupViewModel.Input) -> QuitGroupViewModel.Output {
        let state = State()
        let result = input.groupIdBeginTrigger.flatMapLatest { [unowned self] group in
            return self.userGroupModel.quitUserGroups(groupId: group.id)
                .trackError(state.error)
                .asDriverOnSkipError()
        }
        return QuitGroupViewModel.Output(result: result, error: state.error.asDriver())
    }
}
