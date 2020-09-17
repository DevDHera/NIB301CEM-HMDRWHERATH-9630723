//
//  StatusViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/17/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase

class StatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if Auth.auth().currentUser == nil {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func statusViewClosePressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
}
