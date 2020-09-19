//
//  CreateNotificationViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/19/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class CreateNotificationViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createNotificationPressed(_ sender: UIButton) {
        if let title = titleTextField.text, let description = descriptionTextField.text {
            
            db.collection(Constants.NotificationStore.collectionName).addDocument(data: [
                Constants.NotificationStore.titleField: title,
                Constants.NotificationStore.descriptionField: description,
                Constants.NotificationStore.createdAtField: Date()
            ]) { (error) in
                if let err = error {
                    SCLAlertView().showError("Firestore Error", subTitle: err.localizedDescription)
                } else {
                    self.titleTextField.text = ""
                    self.descriptionTextField.text = ""
                    SCLAlertView().showSuccess("Success", subTitle: "Notification created successfully")
                }
            }
        }
    }
}
