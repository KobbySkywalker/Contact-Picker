//
//  String.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation

extension String {

    public func isValidEmail() -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)

    }

    func containsCapitalLetter() -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }

    func containsNumber() -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return texttest1.evaluate(with: self)
    }

    func containsSpecialCharacter() -> Bool {
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        return texttest2.evaluate(with: self)
    }

    func contains8Characters() -> Bool {
        return self.count >= 8
    }

    public func isValidPassword() -> Bool {
        return containsSpecialCharacter() || containsNumber() || containsCapitalLetter() || contains8Characters()
    }
}
