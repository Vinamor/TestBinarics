//
//  BalanceTableViewCell.swift
//  My Money Flow
//
//  Created by Marta Romaniv on 06.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {
    @IBOutlet weak var theSumLabel: UILabel!
    @IBOutlet weak var theDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
