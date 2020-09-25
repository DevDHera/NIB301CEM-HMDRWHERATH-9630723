//
//  LoginViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/17/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let validation: ValidationService
    
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
        }
    }
    
    
    @IBAction func loginViewClosePressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        do {
            let email = try validation.validateEmail(emailTextField.text)
            let password = try validation.validatePassword(passwordTextField.text)
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    SCLAlertView().showError("Login Error", subTitle: e.localizedDescription)
                } else {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
            }
        } catch {
            SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
        }
//        if let email = emailTextField.text, let password = passwordTextField.text {
//            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                if let e = error {
//                    print(e)
//                    SCLAlertView().showError("Login Error", subTitle: e.localizedDescription)
//                } else {
//                    self.emailTextField.text = ""
//                    self.passwordTextField.text = ""
//                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
//                }
//            }
//        }
    }
}
