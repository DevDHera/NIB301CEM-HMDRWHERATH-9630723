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
    @IBOutlet weak var biometricButton: UIButton!
    
    private let validation: ValidationService
    let biometricAuthService = BiometricAuthService()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let biometricEnabled = UserDefaults.standard.value(forKey: Constants.biometricEnabled) as? Bool
        
        if biometricEnabled != nil && biometricEnabled == true && biometricAuthService.canEvaluvatePolicy() {
            biometricButton.isHidden = false
        } else {
            biometricButton.isHidden = true
        }
        
        switch biometricAuthService.biometricType() {
        case .faceID:
            biometricButton.setBackgroundImage(UIImage(systemName: "faceid"), for: UIControl.State.normal)
        default:
            biometricButton.setBackgroundImage(UIImage(systemName: "viewfinder"), for: UIControl.State.normal)
        }
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
            
            authenticateUserWithEmailPassword(email: email, password: password)
            
//            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                if let e = error {
//                    print(e)
//                    SCLAlertView().showError("Login Error", subTitle: e.localizedDescription)
//                } else {
//                    //                    save user creds in keychain
//                    if UserDefaults.standard.value(forKey: Constants.userName) == nil {
//                        //                        save username into defaults
//                        let userDefaults = UserDefaults.standard
//                        userDefaults.set(email, forKey: Constants.userName)
//                        userDefaults.synchronize()
//
//                        //                        save password into keychain
//                        let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: email, accessGroup: KeychainConfig.accessGroup)
//
//                        do {
//                            try passwordItem.savePassword(password)
//                        } catch let err {
//                            fatalError("Error updating keychain: \(err.localizedDescription)")
//                        }
//                    }
//
//                    self.emailTextField.text = ""
//                    self.passwordTextField.text = ""
//                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
//                }
//            }
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
    
    func authenticateUserWithEmailPassword(email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    SCLAlertView().showError("Login Error", subTitle: e.localizedDescription)
                } else {
                    //                    save user creds in keychain
                    if UserDefaults.standard.value(forKey: Constants.userName) == nil || UserDefaults.standard.value(forKey: Constants.userName) as? String != email {
                        //                        save username into defaults
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(email, forKey: Constants.userName)
                        userDefaults.synchronize()
                        
                        //                        save password into keychain
                        let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: email, accessGroup: KeychainConfig.accessGroup)
                        
                        do {
                            try passwordItem.savePassword(password)
                        } catch let err {
                            fatalError("Error updating keychain: \(err.localizedDescription)")
                        }
                    }
                    
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
            }
    }
    
    @IBAction func signInWithBiometricsPressed(_ sender: UIButton) {
        biometricAuthService.authenticateUser { (message) in
            if let message = message {
                SCLAlertView().showError("Biometric Error", subTitle: message)
                return
            }
            
            if let username = UserDefaults.standard.value(forKey: Constants.userName) as? String {
                do {
                    let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: username, accessGroup: KeychainConfig.accessGroup)
                    
                    let password = try passwordItem.readPassword()
                    self.authenticateUserWithEmailPassword(email: username, password: password)
                } catch let err {
                    SCLAlertView().showError("Login Error", subTitle: err.localizedDescription)
                }
            }
        }
    }
}
