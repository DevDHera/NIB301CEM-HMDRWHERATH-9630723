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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var bodyTempLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
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
                        print(data)
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
                            
                            if let profileImage = data[Constants.UserStore.profileImageField] as? String {
                            
                                let url = URL(string: profileImage)
                                
                                let task = URLSession.shared.dataTask(with: url!) { (data, _, error) in
                                    guard let data = data, error == nil else {
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        let image = UIImage(data: data)
                                        self.profileImageView.image = image
                                    }
                                }
                                
                                task.resume()
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
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            let ref = "\(Constants.Storage.path)/\(uid).png"
            
            storage.child(ref).putData(imageData, metadata: nil, completion: { _, error in
                if let e = error {
                    SCLAlertView().showError("Upload Error", subTitle: e.localizedDescription)
                    return
                }
                
                self.storage.child(ref).downloadURL { (url, error) in
                    guard let url = url, error == nil else {
                        return
                    }
                    
                    let urlString = url.absoluteString
                    
                    self.db.collection(Constants.UserStore.collectionName).document(self.userDocRefId).updateData([
                        Constants.UserStore.profileImageField: urlString
                    ]) { error in
                        if let e = error {
                            SCLAlertView().showError("Upload Error", subTitle: e.localizedDescription)
                            return
                        }
                        SCLAlertView().showSuccess("Success", subTitle: "Successfully Uploaded")
                        
                        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                            guard let data = data, error == nil else {
                                return
                            }
                            
                            DispatchQueue.main.async {
                                let image = UIImage(data: data)
                                self.profileImageView.image = image
                            }
                        }
                        
                        task.resume()
                    }
                }
                
            })
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
                    SCLAlertView().showSuccess("Success", subTitle: "Successfully Updated")
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
