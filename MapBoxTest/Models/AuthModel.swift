//
//  AuthModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift

class AuthModel {
    // swiftlint:disable todo
    func checkLogin() -> Observable<Bool> {
        return Observable.create { observer in
            //TODO: check login
            observer.onNext(false)
            return Disposables.create()
        }
    }

    func login(with user: UserModel) -> Observable<UserModel> {
        guard let url = URL(string: "http://192.168.0.3:8081/api/users/login") else {
            return Observable<UserModel>.error(RxError.unknown)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(user)
        return URLSession.shared.rx.data(request: urlRequest)
            .flatMap { (data) -> Observable<UserModel> in
                let user = try JSONDecoder().decode(UserModel.self, from: data)
                return Observable<UserModel>.just(user)
            }.do(onError: { (error) in
                print(error)
            }).observeOn(MainScheduler.instance)
    }
}
