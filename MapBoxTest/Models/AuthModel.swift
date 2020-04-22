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
        guard let myUserData = UserDefaults.standard.data(forKey: "myUserData"),
            let user = try? JSONDecoder().decode(UserModel.self, from: myUserData) else {
                return Observable<Bool>.just(false)
        }
        return Observable.create { observer in
            //TODO: check login
            observer.onNext(user.mailAddress.count > 0 && user.passWord.count > 0)
            observer.onCompleted()
            return Disposables.create()
        }
    }

    func login(with user: UserModel) -> Observable<UserModel> {
        //ローカルのloginURL
        guard let url = URL(string: "http://192.168.0.3:8080/api/users/login") else {
            return Observable<UserModel>.error(RxError.unknown)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(user)
        return URLSession.shared.rx.data(request: urlRequest)
            .flatMap { (data) -> Observable<UserModel> in
                let user = try? JSONDecoder().decode(UserModel.self, from: data)
                if let _ = user {
                    UserDefaults.standard.set(data, forKey: "myUserData")
                } else if let error = try? JSONDecoder().decode(MBTError.self, from: data) {
                    print(error)
                }
                return Observable<UserModel>.just(user ?? UserModel.init(mailAddress: "", passWord: ""))
            }.observeOn(MainScheduler.instance)
    }
}
