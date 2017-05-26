//
//  RoundedTextField.swift
//  BibleApp
//
//  Created by Ostap Romaniv on 4/28/17.
//  Copyright © 2017 Igor Makara. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height/2
        clipsToBounds = true
    }
}
