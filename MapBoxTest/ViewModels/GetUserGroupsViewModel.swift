//
//  GetUserGroupsViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/30.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import RxCocoa

class GetUserGroupsViewModel: ViewModelType {

    struct Input {
        let checkTrigger: Driver<Void>
    }

    struct Output {
        let groups: Driver<[Group]>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let groupModel: GroupModel

    init(with groupModel: GroupModel) {
        self.groupModel = groupModel
    }

    func transform(input: GetUserGroupsViewModel.Input) -> GetUserGroupsViewModel.Output {
        let state = State()
        let groups: Driver<[Group]> = input.checkTrigger
            .flatMapLatest { [unowned self] in
                return self.groupModel
                    .getUserGroups()
                    .trackError(state.error)
                    .asDriverOnSkipError()
        }
        return GetUserGroupsViewModel.Output(groups: groups, error: state.error.asDriver())
    }
}
