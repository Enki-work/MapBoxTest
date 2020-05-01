//
//  Observable+Ext.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            #if DEBUG
                assertionFailure("Error \(error)")
            #endif
            return Driver.empty()
        }
    }

    func asDriverOnSkipError() -> Driver<E> {
        return asDriver { error in
            debugPrint("asDriverOnSkipError error: \(error)")
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func checkAccountValidity() -> Observable<E> {
        return self.do(onError: { (error) in
            switch error {
            case let RxCocoa.RxCocoaURLError.httpRequestFailed(httpResponse, _):
                if httpResponse.statusCode == 401,
                    let delegate = UIApplication.shared.delegate as? AppDelegate,
                    let naviVC = delegate._keyWindow()?.rootViewController as? UINavigationController,
                    let mapVC = naviVC.viewControllers.first(where: {$0 is MapViewController}){
                    naviVC.popToViewController(mapVC, animated: false)
                    MapViewNavigator.init(with: mapVC).toLogin()
                }
            default:
                break
            }
        })
    }
}
