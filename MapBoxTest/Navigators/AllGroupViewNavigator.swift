//
//  AllGroupViewNavigator.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/10.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit

class AllGroupViewNavigator: MBNavigatorProtocol {
    internal weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func toGroupManageView() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
