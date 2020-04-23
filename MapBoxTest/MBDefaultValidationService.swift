//
//  MBDefaultValidationService.swift
//  MapBoxTest
//
//  Created by setsu on 2020/04/21.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import Foundation
import RxSwift

class MBDefaultValidationService: MBValidationServiceProtocol {
    /// パスワード制限字数
    let minPasswordCount = 5

    /// メールアドレス検証用
    /// - Parameter email: 入力されたメールアドレス
    /// - Returns: 検証結果
    func validateEmail(_ email: String) -> Observable<ValidationResult> {
        if email.isEmpty {
            return .just(.empty)
        }

        if !email.contains("@") {
            return .just(.failed(message: "正しく入力してください"))
        }

        return .just(.success(message: "メールが利用可能"))
    }

    /// パスワード検証用
    /// - Parameter email: 入力されたパスワード
    /// - Returns: 検証結果
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }

        if numberOfCharacters < minPasswordCount {
            return .failed(message: "\(minPasswordCount)文字以上にする必要がる")
        }

        return .success(message: "正確")
    }

    /// 再確認パスワード検証用
    /// - Parameter email: 入力された再確認パスワード
    /// - Returns: 検証結果
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }

        if repeatedPassword == password {
            return .success(message: "正確")
        } else {
            return .failed(message: "パスワードが異なっている")
        }
    }
}
