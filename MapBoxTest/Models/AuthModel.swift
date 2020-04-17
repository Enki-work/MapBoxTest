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
    
    func checkLogin() -> Observable<Bool> {
        return Observable.create { observer in
            //TODO: check login
            observer.onNext(false)
            return Disposables.create()
        }
    }
    
    func login(with email: String, and password: String) -> Observable<UserModel> {
        return Observable.create { observer in
            //TODO: Login
            observer.onNext(UserModel.init(mail: email, pwd: password))
            return Disposables.create()
        }
    }
}
