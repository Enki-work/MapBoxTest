//
//  AuthModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift

final class AuthModel {
    class func getMe() -> Observable<UserModel?> {
        return UserDefaults.standard.rx.observe(Data.self, "myUserData").map { (data) -> UserModel? in
            guard let data = data else { return nil }
            return try? JSONDecoder().decode(UserModel.self, from: data)
        }
    }

    // swiftlint:disable todo
    func checkLogin() -> Observable<Bool> {
        return AuthModel.getMe().map { (user) -> Bool in
            guard let user = user else {
                return false
            }
            //TODO: check login
            return user.mailAddress.count > 0 && user.passWord.count > 0
        }
    }

    func login(with user: UserModel) -> Observable<UserModel> {
        guard let url = URL(string: MBTUrlString.hostUrlString + MBTUrlString.loginUrlString) else {
            return Observable<UserModel>.error(RxError.unknown)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(user)
        return URLSession.shared.rx.data(request: urlRequest)
            .flatMap { (data) -> Observable<UserModel> in
                let user = try? JSONDecoder().decode(UserModel.self, from: data)
                if user != nil {
                    UserDefaults.standard.set(data, forKey: "myUserData")
                } else if let error = try? JSONDecoder().decode(MBTError.self, from: data) {
                    print(error)
                }
                return Observable<UserModel>.just(user ?? UserModel.init(mailAddress: "", passWord: ""))
            }.observeOn(MainScheduler.instance)
            .do(onError: { (error) in
                print(error)
            }).observeOn(MainScheduler.instance)
    }

    func register(with user: UserModel) -> Observable<UserModel> {
        //ローカルのregisterURL
        guard let url = URL(string: MBTUrlString.hostUrlString + MBTUrlString.loginUrlString) else {
            return Observable<UserModel>.error(RxError.unknown)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(user)
        return URLSession.shared.rx.data(request: urlRequest)
            .flatMap { (data) -> Observable<UserModel> in
                let user = try? JSONDecoder().decode(UserModel.self, from: data)
                if let error = try? JSONDecoder().decode(MBTError.self, from: data) {
                    print(error)
                }
                return Observable<UserModel>.just(user ?? UserModel.init(mailAddress: "", passWord: ""))
            }.do(onError: { (error) in
                print(error)
            }).observeOn(MainScheduler.instance)
    }
}
