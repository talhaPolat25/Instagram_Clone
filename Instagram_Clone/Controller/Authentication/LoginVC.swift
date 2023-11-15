//
//  ViewController.swift
//  Instagram_Clone
//
//  Created by talha polat on 31.10.2023.
//

import UIKit
import Firebase
class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnShowPassword(_ sender: UIButton) {
        txtPassword.isSecureTextEntry = false
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        guard let email = txtEmail.text,
              let password = txtPassword.text else{return}
        
        Auth.auth().signIn(withEmail: email, password: password){(result,error) in
            if let error = error{
                print("It couldnt sign in to the account")
                return
            }
            self.txtEmail.text = ""
            self.txtPassword.text = ""
        }
    }
    @IBAction func btnLoginIsValid(_ sender: UITextField) {
        if txtPassword.text?.count ?? 0 > 0 && txtEmail.text?.count ?? 0 > 0 {
            btnLogin.isEnabled = true
        }
    }
    
    @IBAction func didTapOutside(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

