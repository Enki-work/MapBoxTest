//
//  LogoutNavigator.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/01.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit

class LogoutNavigator: MBNavigatorProtocol {
    internal weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func toLogin() {
        performSegue(with: .mapToLogin)
    }
}
