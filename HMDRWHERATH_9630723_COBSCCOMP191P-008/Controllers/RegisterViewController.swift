//
//  RegisterViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/17/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
        }
    }
    
    @IBAction func alreadyHaveAnAccountPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerViewClosePressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    SCLAlertView().showError("Registration Error", subTitle: e.localizedDescription)
                } else {
                    if let uid = authResult?.user.uid {
                        self.db.collection(Constants.UserStore.collectionName).addDocument(data: [
                            Constants.UserStore.uidField: uid,
                            Constants.UserStore.firstNameField: firstName,
                            Constants.UserStore.lastNameField: lastName,
                            Constants.UserStore.emailField: email,
                            Constants.UserStore.bodyTemperatureField: 0.0
                        ]) { (error) in
                            if let err = error {
                                SCLAlertView().showError("Firestore Error", subTitle: err.localizedDescription)
                            } else {
                                self.firstNameTextField.text = ""
                                self.lastNameTextField.text = ""
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                                self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
}

