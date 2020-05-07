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

extension ObservableType where Element == Bool {
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

    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            #if DEBUG
                assertionFailure("Error \(error)")
            #endif
            return Driver.empty()
        }
    }

    func asDriverOnSkipError() -> Driver<Element> {
        return asDriver { error in
            debugPrint("asDriverOnSkipError error: \(error)")
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func checkAccountValidity() -> Observable<Element> {
        return self.do(onError: { (error) in
            switch error {
            case let RxCocoa.RxCocoaURLError.httpRequestFailed(httpResponse, _):
                if httpResponse.statusCode == 401,
                    let delegate = UIApplication.shared.delegate as? AppDelegate,
                    let naviVC = delegate.currentKeyWindow()?.rootViewController as? UINavigationController,
                    let mapVC = naviVC.viewControllers.first(where: { $0 is MapViewController }) {
                    naviVC.popToViewController(mapVC, animated: false)
                    MapViewNavigator.init(with: mapVC).toLogin()
                }
            default:
                break
            }
        })
    }
}
