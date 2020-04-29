//
//  File.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/28.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import RxCocoa

class GetUserLocationsViewModel: ViewModelType {

    struct Input {
        let checkTrigger: Driver<Void>
    }

    struct Output {
        let locations: Driver<[Location]>
        let error: Driver<Error>
    }

    struct State {
        let error = ErrorTracker()
    }

    private let locationModel: LocationModel

    init(with locationModel: LocationModel) {
        self.locationModel = locationModel
    }

    func transform(input: GetUserLocationsViewModel.Input) -> GetUserLocationsViewModel.Output {
        let state = State()
        let locations: Driver<[Location]> = input.checkTrigger
            .flatMapLatest { [unowned self] in
                return self.locationModel
                    .getUserLocations()
                    .trackError(state.error)
                    .asDriverOnSkipError()
        }
        return GetUserLocationsViewModel.Output(locations: locations, error: state.error.asDriver())
    }
}
