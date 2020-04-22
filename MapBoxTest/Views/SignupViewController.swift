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
    @IBOutlet weak var emailValidationOutlet: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    @IBOutlet weak var repeatedPasswordTextField: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    @IBOutlet weak var finishBtn: UIButton!

    // MARK: - Constants

    private lazy var signupViewModel: SignupViewModel = {
        return SignupViewModel()
    }()

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
        repeatedPasswordTextField.delegate = self
    }

    private func bindViewModel() {
        let input = SignupViewModel.Input(signupTrigger: UIButton().rx.tap.asDriver(),
                                          email: emailTextField.rx.text.orEmpty.asDriver(),
                                          password: passwordTextField.rx.text.orEmpty.asDriver(),
                                          repeatedPassword: repeatedPasswordTextField.rx.text.orEmpty.asDriver())
        let output = signupViewModel.transform(input: input)

        output.validatedEmail
            .drive(emailValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)

        output.validatedPassword
            .drive(passwordValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)

        output.validatedPasswordRepeated
            .drive(repeatedPasswordValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)

        output.signupEnabled.drive(onNext: { [weak self] valid in
            self?.finishBtn.isEnabled = valid
            self?.finishBtn.alpha = valid ? 1.0 : 0.5
        }).disposed(by: disposeBag)

        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
