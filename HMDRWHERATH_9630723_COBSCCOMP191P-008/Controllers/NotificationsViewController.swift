//
//  NotificationsViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/19/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var notificationCells: [NotificationCell] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.allNotifications
//        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        getNotifications()
    }
    
    func getNotifications() {
        db.collection(Constants.NotificationStore.collectionName).order(by: Constants.NotificationStore.createdAtField, descending: true).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapshotDocuemnts = querySnapshot?.documents {
                    self.notificationCells = []
                    for doc in snapshotDocuemnts {
                        let data = doc.data()
                        let cell = NotificationCell(title: data[Constants.NotificationStore.titleField] as! String, description: data[Constants.NotificationStore.descriptionField] as! String)
                        
                        self.notificationCells.append(cell)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.notificationCellIdentifier, for: indexPath)
        cell.textLabel?.text = notificationCells[indexPath.row].title
        cell.detailTextLabel?.text = notificationCells[indexPath.row].description
        return cell
    }
    
    
}
