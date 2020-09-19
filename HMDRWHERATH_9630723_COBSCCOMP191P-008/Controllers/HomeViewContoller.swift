//
//  ViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/16/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase

class HomeViewContoller: UIViewController {
    
    @IBOutlet weak var infectedCountLabel: UILabel!
    @IBOutlet weak var deathCountLabel: UILabel!    
    @IBOutlet weak var recoveredCountLabel: UILabel!
    
    let db = Firestore.firestore()
    var summeryView = ["infected": 0, "deaths": 0, "recovers": 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func fetchUsers() {
        summeryView = ["infected": 0, "deaths": 0, "recovers": 0]
        db.collection(Constants.UserStore.collectionName).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                
                if let snapshotDocuemnts = querySnapshot?.documents {
                    for doc in snapshotDocuemnts {
                        let data = doc.data()
                        if let status = data[Constants.UserStore.covidStatus] as? String {
                            if status == UserCovidStatus.INFECTED.rawValue {
                                self.summeryView["infected"] = self.summeryView["infected"]! + 1
                            } else if status == UserCovidStatus.DEATH.rawValue {
                                self.summeryView["deaths"] = self.summeryView["deaths"]! + 1
                            } else if status == UserCovidStatus.RECOVERED.rawValue {
                                self.summeryView["recovers"] = self.summeryView["recovers"]! + 1
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.infectedCountLabel.text = "\(self.summeryView["infected"]!)"
                        self.deathCountLabel.text = "\(self.summeryView["deaths"]!)"
                        self.recoveredCountLabel.text = "\(self.summeryView["recovers"]!)"
                    }
                }
            }
        }
    }
    
}

