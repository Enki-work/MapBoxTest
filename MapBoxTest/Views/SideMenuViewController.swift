//
//  SideMenuViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/27.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift

class SideMenuViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellTitleList: [String] = ["マイローケーション"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleList.count
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuListIatem", for: indexPath)

        cell.textLabel?.text = cellTitleList[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
