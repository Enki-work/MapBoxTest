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

    func transform(input: MapViewTitleViewModel.Input) -> MapViewTitleViewModel.Output {
        let state = State()
        let selectedGroupTitle = input.beginTrigger
            .flatMapLatest {
                return AuthModel.getMe()
                    .trackError(state.error)
                    .asDriverOnSkipError()
            }.asObservable().flatMap { (user) -> Driver<SimpleGroupInfo> in
                guard let userModel = user,
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
