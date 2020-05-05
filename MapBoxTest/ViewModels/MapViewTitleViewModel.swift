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
        let selectedGroupTitle: Driver<String>
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
            .flatMap { (combineData) -> Driver<String> in
                guard let userModel = combineData.1,
                    let selectedGroupId = UserDefaults.standard
                    .string(forKey: "selectedGroupId\(userModel.mailAddress)"),
                    let selectedGroupName = combineData.0.first(where: { $0.id == selectedGroupId })?.title else {
                        return Driver<String>.just("すべて")
                }
                return Driver<String>.just(selectedGroupName)
        }
        return MapViewTitleViewModel.Output(selectedGroupTitle: selectedGroupTitle.asDriverOnSkipError(),
                                            error: state.error.asDriver())
    }
}
