//
//  SurveyViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/19/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class SurveyViewController: UIViewController {

    @IBOutlet weak var surveyImage: UIImageView!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var surveyQuestionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    let db = Firestore.firestore()
    
    var surveyBrain = SurveyBrain()
    var userDocRefId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        fetchUser()
    }
        
    @IBAction func answerPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle!
        surveyBrain.checkAnswer(userAnswer)
        surveyBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
        if surveyBrain.getCompleted() {
            var status = UserCovidStatus.NONE.rawValue
            if surveyBrain.getScore() > 2 {
                status = UserCovidStatus.INFECTED.rawValue
            }
            
            updateSurveyResult(score: surveyBrain.getScore(), status: status)
         }
        
    }
    
    @objc func updateUI() {
        surveyTitleLabel.text = surveyBrain.getQuestionTitle()
        surveyQuestionLabel.text = surveyBrain.getQuestionText()
        surveyImage.image = #imageLiteral(resourceName: surveyBrain.getQuestionImage())
        progressView.progress = surveyBrain.getProgress()
    }
    
    func fetchUser() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection(Constants.UserStore.collectionName).whereField(Constants.UserStore.uidField, isEqualTo: uid).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                    SCLAlertView().showError("Error", subTitle: e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        self.userDocRefId = snapshotDocuments[0].documentID
                    }
                    
                }
            }
        }
    }
    
    func updateSurveyResult(score: Int, status: String) {
        if userDocRefId != "" {
                db.collection(Constants.UserStore.collectionName).document(userDocRefId).updateData([
                    Constants.UserStore.surveyResultField: score,
                    Constants.UserStore.covidStatus: status
                ]) { error in
                    if let e = error {
                        SCLAlertView().showError("Update Error", subTitle: e.localizedDescription)
                        return
                    }
                    
                    SCLAlertView().showSuccess("Success", subTitle: "You successfully completed the survey")
                    self.surveyBrain.resetCounts()
                    self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
