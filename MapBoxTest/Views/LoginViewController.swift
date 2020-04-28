//
//  LoginViewController.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/15.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: BaseViewController {
    // MARK: - IBOutlet

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailValidationOutlet: UILabel!
    @IBOutlet weak var passwordValidationOutlet: UILabel!

    // MARK: - Variables

    private lazy var loginViewModel: LoginViewModel = {
        return LoginViewModel(with: AuthModel(),
                              and: LoginNavigator(with: self))
    }()

    // MARK: - Constants

    let disposeBag = DisposeBag()

    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        bindViewModel()
    }

    // MARK: - Private Methods

    private func initializeUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    private func bindViewModel() {
        let input = LoginViewModel.Input(loginTrigger: loginButton.rx.tap.asDriver(),
                                         signupTrigger: signupButton.rx.tap.asDriver(),
                                         mailaddress: emailTextField.rx.text
                                             .map { if let text = $0 { return text } else { return "" } }
                                             .asDriver(onErrorJustReturn: ""),
                                         password: passwordTextField.rx.text
                                             .map { if let text = $0 { return text } else { return "" } }
                                             .asDriver(onErrorJustReturn: ""))
        let output = loginViewModel.transform(input: input)

        output.login.drive(onNext: userWillLogin).disposed(by: disposeBag)
        output.signup.drive().disposed(by: disposeBag)

        output.validatedEmail
            .drive(emailValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)

        output.validatedPassword
            .drive(passwordValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)

        output.error.drive(onNext: presentErrorAlert).disposed(by: disposeBag)
    }

    private func userWillLogin(user: UserModel) {
        guard user.mailAddress.count > 0, user.passWord.count > 0 else {
            presentValidateAlert()
            return
        }
    }

    private func presentValidateAlert() {
        let alert = UIAlertController(title: "認証エラー",
                                      message: "メールとパスワードを確認してください",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
