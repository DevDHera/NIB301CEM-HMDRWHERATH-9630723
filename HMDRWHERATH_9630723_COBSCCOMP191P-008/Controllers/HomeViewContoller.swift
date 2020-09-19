//
//  ViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/16/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class HomeViewContoller: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var infectedCountLabel: UILabel!
    @IBOutlet weak var deathCountLabel: UILabel!    
    @IBOutlet weak var recoveredCountLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var notificationTitleLabel: UILabel!    
    @IBOutlet weak var notificationDescriptionLabel: UILabel!
    
    let db = Firestore.firestore()
    let locationManager = CLLocationManager()
    var summeryView = ["infected": 0, "deaths": 0, "recovers": 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        getRecentNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
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
    
    func getRecentNotification() {
        db.collection(Constants.NotificationStore.collectionName).order(by: Constants.NotificationStore.createdAtField, descending: true).limit(to: 1).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapshotDocuemnts = querySnapshot?.documents {
                    let data = snapshotDocuemnts[0].data()
                    
                    if let title = data[Constants.NotificationStore.titleField] as? String, let description = data[Constants.NotificationStore.descriptionField] as? String {
                        DispatchQueue.main.async {
                            self.notificationTitleLabel.text = title
                            self.notificationDescriptionLabel.text = description
                        }
                    }
                }
            }
        }
    }
    
}

