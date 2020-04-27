//
//  MapViewNavigator.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/16.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import SideMenu

class MapViewNavigator: MBNavigatorProtocol {
    internal weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func toLogin() {
        performSegue(with: .mapToLogin)
    }

    func toSideMenu() {
        if let leftMenuNavigationController = SideMenuManager.default.leftMenuNavigationController {
            viewController?.present(leftMenuNavigationController, animated: true, completion: nil)
        }
    }
}
