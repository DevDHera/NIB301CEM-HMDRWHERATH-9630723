//
//  BiometricViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/26/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import SCLAlertView

class BiometricViewController: UIViewController {
    @IBOutlet weak var biometricImage: UIImageView!
    
    let biometricAuthService = BiometricAuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var biometricType = ""
        
        switch biometricAuthService.biometricType() {
        case .faceID:
//            biometricType = "FaceID"
            biometricImage.image = UIImage(systemName: "faceid")
        default:
//            biometricType = "TouchID"
            biometricImage.image = UIImage(systemName: "viewfinder")
        }
    }
    
    @IBAction func enableBiometricPressed(_ sender: UIButton) {
        biometricAuthService.authenticateUser { (message) in
            guard message == nil else {
                SCLAlertView().showError("Biometric Error", subTitle: message ?? "Unknown Error")
                return
            }
            
            UserDefaults.standard.set(true, forKey: Constants.biometricEnabled)
            UserDefaults.standard.synchronize()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
