//
//  MapViewTitleViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/05.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class MapViewTitleViewModel: ViewModelType {

    struct Input {
        let beginTrigger: Driver<Void>
    }

    struct Output {
        let selectedGroup: Driver<SimpleGroupInfo>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let groupModel: GroupModel

    init(with groupModel: GroupModel) {
        self.groupModel = groupModel
    }

    func transform(input: MapViewTitleViewModel.Input) -> MapViewTitleViewModel.Output {
        let state = State()
        let groups = input.beginTrigger
            .flatMapLatest { [unowned self] in
                return self.groupModel
                    .getUserGroups()
                    .trackError(state.error)
                    .asDriverOnSkipError()
            }.asObservable()

        let selectedGroupTitle = Observable.combineLatest(groups, AuthModel.getMe())
            .flatMap { (combineData) -> Driver<SimpleGroupInfo> in
                guard let userModel = combineData.1,
                    let selectedGroupData = UserDefaults.standard
                    .data(forKey: "selectedGroup\(userModel.mailAddress)"),
                    let group = try? JSONDecoder().decode(SimpleGroupInfo.self, from: selectedGroupData) else {
                        return Driver<SimpleGroupInfo>.just(SimpleGroupInfo(id: "", title: "すべて"))
                }
                return Driver<SimpleGroupInfo>.just(group)
        }
        return MapViewTitleViewModel.Output(selectedGroup: selectedGroupTitle.asDriverOnSkipError(),
                                            error: state.error.asDriver())
    }
}
