//
//  ColorPointAnnotation.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/19/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import MapKit

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor

    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}
