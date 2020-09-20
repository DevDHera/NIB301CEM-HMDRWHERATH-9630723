//
//  StatusViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/17/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class StatusViewController: UIViewController {
    
    @IBOutlet weak var createNotificationView: UIView!
    @IBOutlet weak var newSurveyView: UIView!
    @IBOutlet weak var bodyTempTextField: UITextField!
    @IBOutlet weak var bodyTempLabel: UILabel!    
    @IBOutlet weak var lastUpdatedAtLabel: UILabel!
    
    let db = Firestore.firestore()
    
    var userDocRefId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let createNoticationViewWithAction = UITapGestureRecognizer(target: self, action: #selector(createNotificationAction(_:)))
        createNotificationView.addGestureRecognizer(createNoticationViewWithAction)
        
        let newSurveyViewWithAction = UITapGestureRecognizer(target: self, action: #selector(surveyAction(_:)))
        newSurveyView.addGestureRecognizer(newSurveyViewWithAction)
        
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        createNotificationView.isHidden = true
        
        if Auth.auth().currentUser == nil {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func statusViewClosePressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
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
                        if let bodyTemp = data[Constants.UserStore.bodyTemperatureField] as? Double, let lastBodyTempUpdateAt = data[Constants.UserStore.lastBodyTempUpdatedAtField] as? Timestamp, let role = data[Constants.UserStore.roleField] as? String {
                            DispatchQueue.main.async {
                                if role != UserRole.STUDENT.rawValue {
                                    self.createNotificationView.isHidden = false
                                }
                            }
                            
                            let formatter = MeasurementFormatter()
                            let measurement = Measurement(value: bodyTemp, unit: UnitTemperature.celsius)
                            let temperature = formatter.string(from: measurement)
                            self.bodyTempLabel.text = temperature
                            
                            let dateFormatter = RelativeDateTimeFormatter()
                            dateFormatter.unitsStyle = .full
                            let lastUpdate = dateFormatter.localizedString(for: lastBodyTempUpdateAt.dateValue(), relativeTo: Date())
                            self.lastUpdatedAtLabel.text = "Last Update: \(lastUpdate)"
                            
                        } else {
                            self.bodyTempLabel.text = "N/A"
                            self.lastUpdatedAtLabel.text = "Last Update: N/A"
                        }
                        
                        alertViewResponder.close()
                    }
                    
                }
            }
        }
    }
    
    @objc func createNotificationAction(_ sender:UITapGestureRecognizer){
        performSegue(withIdentifier: Constants.statusToCreateNotification, sender: self)
    }
    
    @objc func surveyAction(_ sender:UITapGestureRecognizer){
        performSegue(withIdentifier: Constants.statusToSurvey, sender: self)
    }
    
    @IBAction func updateBodyTempPressed(_ sender: Any) {
        if let bodyTemp = Double(bodyTempTextField.text!) {
                db.collection(Constants.UserStore.collectionName).document(userDocRefId).updateData([
                    Constants.UserStore.bodyTemperatureField: bodyTemp,
                    Constants.UserStore.lastBodyTempUpdatedAtField: Date()
                ]) { error in
                    if let e = error {
                        SCLAlertView().showError("Update Error", subTitle: e.localizedDescription)
                        return
                    }
                    
                    let formatter = MeasurementFormatter()
                    let measurement = Measurement(value: bodyTemp, unit: UnitTemperature.celsius)
                    let temperature = formatter.string(from: measurement)
                    self.bodyTempLabel.text = temperature
                    
                    let dateFormatter = RelativeDateTimeFormatter()
                    dateFormatter.unitsStyle = .full
                    let lastUpdate = dateFormatter.localizedString(for: Date(), relativeTo: Date())
                    self.lastUpdatedAtLabel.text = "Last Update: \(lastUpdate)"
            }
        }
        
    }
    
}
