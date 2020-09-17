//
//  SettingsViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/17/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if Auth.auth().currentUser != nil {
            logoutButton.isHidden = false
        } else {
            logoutButton.isHidden = true
        }
    }
    
    @IBAction func settingsViewClosePressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.tabBarController?.selectedIndex = 0
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            SCLAlertView().showError("Registration Error", subTitle: signOutError as! String)
        }
        
    }
}
