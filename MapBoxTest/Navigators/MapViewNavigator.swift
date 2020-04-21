//
//  MapViewNavigator.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/16.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import UIKit

class MapViewNavigator {
    private weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func toLogin() {
        viewController?.performSegue(withIdentifier: "toLogin", sender: nil)
    }
}
