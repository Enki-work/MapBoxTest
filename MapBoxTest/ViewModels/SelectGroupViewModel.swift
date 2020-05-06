//
//  SelectGroupViewModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/06.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class SelectGroupViewModel: ViewModelType {

    struct Input {
        let groupIdBeginTrigger: Driver<SimpleGroupInfoProtocol>
    }

    struct Output {
        let locations: Driver<(SimpleGroupInfoProtocol, [Location])>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let locationModel: LocationModel
    private let navigator: MyGroupViewNavigator?

    init(with locationModel: LocationModel,
         navigator: MyGroupViewNavigator? = nil) {
        self.locationModel = locationModel
        self.navigator = navigator
    }

    func transform(input: SelectGroupViewModel.Input) -> SelectGroupViewModel.Output {
        let state = State()

        let locations: Driver<(SimpleGroupInfoProtocol, [Location])> = Observable.combineLatest(input.groupIdBeginTrigger.asObservable(), AuthModel.getMe())
            .flatMapLatest { [weak self](combineData) -> Observable<(SimpleGroupInfoProtocol, [Location])> in
                guard let self = self, let user = combineData.1 else
                { return Observable<(SimpleGroupInfoProtocol, [Location]) > .error(RxError.noElements) }
                if let simpleGroupData = try? JSONEncoder()
                    .encode(SimpleGroupInfo(id: combineData.0.id, title: combineData.0.title)) {
                    UserDefaults.standard.set(simpleGroupData, forKey: "selectedGroup\(user.mailAddress)")
                }
                self.navigator?.toMapView()
                return self.locationModel
                    .getGroupLocations(groupId: combineData.0.id)
                    .map {
                        (combineData.0, $0)
                    }
                    .trackError(state.error)
            }.asDriverOnSkipError()

        return SelectGroupViewModel.Output(locations: locations, error: state.error.asDriver())
    }
}
