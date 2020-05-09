//
//  GroupManageNavigator.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/05/09.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit

class GroupManageNavigator: MBNavigatorProtocol {
    internal weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAllGroups() {
        let groupsVC = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "AllGroupViewController")
        groupsVC.preferredContentSize = .init(width: 250, height: 200)
        groupsVC.modalPresentationStyle = .popover
        groupsVC.popoverPresentationController?.barButtonItem = viewController?
            .navigationItem.rightBarButtonItem
        groupsVC.popoverPresentationController?.permittedArrowDirections = [.any]
        groupsVC.popoverPresentationController?.canOverlapSourceViewRect = false
        groupsVC.popoverPresentationController?.delegate = viewController as? GroupManageViewController
        viewController?.present(groupsVC, animated: true, completion: nil)
    }
}
