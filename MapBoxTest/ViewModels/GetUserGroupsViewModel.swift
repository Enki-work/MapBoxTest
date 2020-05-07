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
    private let isSelectMode: Bool

    init(with groupModel: GroupModel, isSelectMode: Bool = true) {
        self.groupModel = groupModel
        self.isSelectMode = isSelectMode
    }

    func transform(input: GetUserGroupsViewModel.Input) -> GetUserGroupsViewModel.Output {
        let state = State()
        let groups: Driver<[Group]> = input.checkTrigger
            .flatMapLatest { [unowned self] in
                return self.groupModel
                    .getUserGroups()
                    .trackError(state.error)
                    .asDriverOnSkipError()
            }.map {[weak self] in
                guard self?.isSelectMode == true else { return $0 }
                var groups: [Group] = $0
                groups.insert(Group(title: "すべて"), at: 0)
                return groups
        }
        return GetUserGroupsViewModel.Output(groups: groups, error: state.error.asDriver())
    }
}
