//
//  RoundedButton.swift
//  BibleApp
//
//  Created by Igor Makara on 4/20/17.
//  Copyright © 2017 Igor Makara. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height/2
        clipsToBounds = true
    }

}

