//
//  Survey.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/19/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import Foundation

struct Survey {
    let title: String
    let question: String
    let image: String
    let answer: String
    
    init(t: String, q: String, i: String, a: String) {
        title = t
        question = q
        image = i
        answer = a
    }
}
