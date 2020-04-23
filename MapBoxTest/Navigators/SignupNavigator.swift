//
//  SignupNavigator.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/22.
//  Copyright © 2020 Prageeth. All rights reserved.
//


import UIKit

class SignupNavigator: MBNavigatorProtocol {
    internal weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }
}
