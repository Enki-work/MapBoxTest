//
//  UserGroupModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/08.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import Foundation

final class UserGroupModel {
    func getUserGroups() -> Observable<Void> {
        return AuthModel.getMe().flatMap { (user) -> Observable<Void> in
            guard let user = user, user.token.count > 0 else {
                return Observable<Void>.error(RxError.unknown)
            }
            let params = ["token": user.token].getUrlParams()
            guard let url = URL(string: MBTUrlString.hostUrlString +
                MBTUrlString.getGroupUrlString + params) else {
                return Observable<Void>.error(RxError.unknown)
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            return URLSession.shared.rx.data(request: urlRequest)
                .flatMap { (data) -> Observable<Void> in
                    return Observable<Void>.just(())
                }.do(onError: { (error) in
                    print(error)
                })
        }.observeOn(MainScheduler.instance).checkAccountValidity()
    }
}
