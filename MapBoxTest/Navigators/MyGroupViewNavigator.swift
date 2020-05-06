//
//  MyGroupViewNavigator.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/06.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit

class MyGroupViewNavigator: MBNavigatorProtocol {
    internal weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func toMapView() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
