//
//  Extensions.swift
//  Instagram_Clone
//
//  Created by talha polat on 13.11.2023.
//

import UIKit

extension UITextField{
     func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text)
    }
}
