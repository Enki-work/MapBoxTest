//
//  SignupNavigator.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/22.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation

class SignupNavigator {
    private weak var viewController: LoginViewController?

    init(with viewController: LoginViewController) {
        self.viewController = viewController
    }

    func toSignupView() {
        viewController?.performSegue(withIdentifier: "goToSignup", sender: nil)
    }
}
