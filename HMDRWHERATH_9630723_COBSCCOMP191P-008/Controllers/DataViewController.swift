//
//  DataViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/20/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var displayImage: UIImageView!
    var displayImageString: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageString = displayImageString {
          displayImage.image = #imageLiteral(resourceName: imageString)
        }
    }

}
