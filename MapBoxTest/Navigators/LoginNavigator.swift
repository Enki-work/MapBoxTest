//
//  LoginNavigator.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation

class LoginNavigator {
    private weak var viewController: LoginViewController?

    init(with viewController: LoginViewController) {
        self.viewController = viewController
    }

    func toMap() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
