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
    @IBOutlet weak var tableView: UITableView!
    
    var settingsCells: [SettingsCell] = [
        SettingsCell(title: "Profile", segue: Constants.settingsToProfileSegue),
        SettingsCell(title: "Contact Us / About Us", segue: Constants.settingsToContactUsSegue),
        SettingsCell(title: "Share with Friend", segue: Constants.settingsToShareSegue)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.settingsName
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.settingsCellIdentifier, for: indexPath)
        cell.textLabel?.text = settingsCells[indexPath.row].title
        return cell
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Auth.auth().currentUser == nil, indexPath.row == 0 {
            SCLAlertView().showInfo("Not logged in", subTitle: "Please logged in to access this functionality")
            return
        }
        performSegue(withIdentifier: settingsCells[indexPath.row].segue, sender: self)
    }
}
