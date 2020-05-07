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

    func showGroups() {
        let groupsVC = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "MyGroupViewController")
        groupsVC.preferredContentSize = .init(width: 250, height: 200)
        groupsVC.modalPresentationStyle = .popover
        groupsVC.popoverPresentationController?.sourceView = viewController?.navigationItem.titleView
        groupsVC.popoverPresentationController?.sourceRect = viewController?
            .navigationItem.titleView?.bounds ?? .zero
        groupsVC.popoverPresentationController?.permittedArrowDirections = [.any]
        groupsVC.popoverPresentationController?.canOverlapSourceViewRect = false
        groupsVC.popoverPresentationController?.delegate = viewController as? MapViewController
        viewController?.present(groupsVC, animated: true, completion: nil)
    }
}

extension MapViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            .none
    }
}
