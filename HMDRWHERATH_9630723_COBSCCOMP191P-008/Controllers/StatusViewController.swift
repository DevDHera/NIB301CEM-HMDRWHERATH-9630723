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
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        fetchUser()
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
    
    func fetchUser()  {
//        db.collection(Constants.UserStore.collectionName).getDocuments { (querySnapshot, error) in
//            if let e = error {
//                print(e.localizedDescription)
//            } else {
//
//                if let snapshotDocuemnts = querySnapshot?.documents {
//                    for doc in snapshotDocuemnts {
//                        print(doc.data())
//                    }
//                }
//            }
//        }
        if let uid = Auth.auth().currentUser?.uid {
            db.collection(Constants.UserStore.collectionName).whereField(Constants.UserStore.uidField, isEqualTo: uid).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        let data = snapshotDocuments[0].data()
                        if let firstName = data[Constants.UserStore.firstNameField] as? String {
                            print(firstName)
                            DispatchQueue.main.async {
                                self.firstNameLabel.text = firstName
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
