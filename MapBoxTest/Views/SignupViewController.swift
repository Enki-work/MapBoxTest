//
//  SignupViewController.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/20.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift

class SignupViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comfirmPasswordTextField: UITextField!
    @IBOutlet weak var finishBtn: UIButton!

    // MARK: - Constants

    let disposeBag = DisposeBag()

    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    // MARK: - Private Methods

    private func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        comfirmPasswordTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
