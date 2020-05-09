//
//  GetAllGroupViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/09.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import RxCocoa

class GetAllGroupViewModel: ViewModelType {

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

    func transform(input: GetAllGroupViewModel.Input) -> GetAllGroupViewModel.Output {
        let state = State()
        let groups: Driver<[Group]> = input.checkTrigger
            .flatMapLatest { [unowned self] in
                return self.groupModel
                    .getAllGroups()
                    .trackError(state.error)
                    .asDriverOnSkipError()
            }
        return GetAllGroupViewModel.Output(groups: groups, error: state.error.asDriver())
    }
}
