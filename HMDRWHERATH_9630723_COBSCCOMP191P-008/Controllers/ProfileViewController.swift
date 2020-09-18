//
//  ProfileViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/17/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class ProfileViewController: UIViewController {
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var bodyTempLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let db = Firestore.firestore()
    
    var userDocRefId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.profileName
        
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if Auth.auth().currentUser == nil {
            navigationController?.popToRootViewController(animated: true)
        }
        
        let profileImageViewAction = UITapGestureRecognizer(target: self, action: #selector(imageUIViewAction(_:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageViewAction)
    }
    
    func fetchUser()  {
        if let uid = Auth.auth().currentUser?.uid {
            let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showWait("Fetching...", subTitle: "Wait until we fetch your data")
            
            db.collection(Constants.UserStore.collectionName).whereField(Constants.UserStore.uidField, isEqualTo: uid).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                    SCLAlertView().showError("Error", subTitle: e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        self.userDocRefId = snapshotDocuments[0].documentID
                        let data = snapshotDocuments[0].data()
                        if let bodyTemp = data[Constants.UserStore.bodyTemperatureField] as? Double, let joinedDate = data[Constants.UserStore.joinedDateField] as? Timestamp, let firstName = data[Constants.UserStore.firstNameField] as? String, let lastName = data[Constants.UserStore.lastNameField] as? String {
                            
                            let formatter = MeasurementFormatter()
                            let measurement = Measurement(value: bodyTemp, unit: UnitTemperature.celsius)
                            let temperature = formatter.string(from: measurement)
                            
                            DispatchQueue.main.async {
                                self.bodyTempLabel.text = temperature
                                self.memberSinceLabel.text = "Member since \(joinedDate.dateValue().getFormattedDate(format: "MMM yyyy"))"
                                self.navigationItem.title = "\(firstName) \(lastName)"
                                self.firstNameTextField.text = firstName
                                self.lastNameTextField.text = lastName
                            }
                            
                        } else {
                            self.bodyTempLabel.text = "N/A"
                            self.memberSinceLabel.text = "Member Since: N/A"
                        }
                        
                        alertViewResponder.close()
                    }
                    
                }
            }
        }
    }
    
    @objc func imageUIViewAction(_ sender:UITapGestureRecognizer){
        print("CC")
    }
    
    
    @IBAction func profileUpdatePressed(_ sender: UIButton) {
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
                db.collection(Constants.UserStore.collectionName).document(userDocRefId).updateData([
                    Constants.UserStore.firstNameField: firstName,
                    Constants.UserStore.lastNameField: lastName
                ]) { error in
                    if let e = error {
                        SCLAlertView().showError("Update Error", subTitle: e.localizedDescription)
                        return
                    }
                    SCLAlertView().showSuccess("Success", subTitle: "Successfully Uploaded")
                    self.navigationItem.title = "\(firstName) \(lastName)"
            }
        }
    }
    
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
