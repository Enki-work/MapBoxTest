//
//  MBNavigatorProtocol.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/22.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit

protocol MBNavigatorProtocol {
    var viewController: UIViewController? { get set }

    func performSegue(with identifier: SegueIdentifiers)
    func dismiss()
}

