//
//  ViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/16/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit

class HomeViewContoller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }


}

