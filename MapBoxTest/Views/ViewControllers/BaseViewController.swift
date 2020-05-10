//
//  BaseViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/27.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var defaultDisposeBag = DisposeBag()
    var uiDisposeBag = DisposeBag()
    
    func presentErrorAlert(error: Error) {
        let alert = UIAlertController(title: "認証エラー",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
