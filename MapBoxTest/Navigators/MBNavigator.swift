//
//  MBNavigator.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/22.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit

enum SegueIdentifiers: String {
    case signupToLogin
    case loginToSignup
    case mapToLogin
}

class MBNavigator: MBNavigatorProtocol {

    internal weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func performSegue(with identifier: SegueIdentifiers) {
        viewController?.performSegue(withIdentifier: identifier.rawValue, sender: nil)
    }

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
