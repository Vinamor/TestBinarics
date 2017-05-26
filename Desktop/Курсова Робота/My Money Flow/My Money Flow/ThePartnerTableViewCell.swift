//
//  ThePartnerTableViewCell.swift
//  My Money Flow
//
//  Created by Marta Romaniv on 03.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit

class ThePartnerTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets:
    @IBOutlet weak var PartnerNameSurname: UILabel?
    @IBOutlet weak var PartnerBalance: UILabel?
    @IBOutlet weak var PartnerImage: UIImageView!
    
    @IBOutlet weak var PartnerNameSurname2: UILabel?
    @IBOutlet weak var PartnerImage2: UIImageView!
    @IBOutlet weak var PartnerBalance2: UILabel!
    
    // MARK: - View Controller Life-cycle:
    override func awakeFromNib() {
    
        super.awakeFromNib()
        
        // Initialization code
         designingCells()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func designingCells() {
        self.PartnerImage?.layer.cornerRadius = self.PartnerImage.frame.size.width / 2
        self.PartnerImage?.clipsToBounds = true
        
        self.PartnerImage2?.layer.cornerRadius = self.PartnerImage2.frame.size.width / 2
        self.PartnerImage2?.clipsToBounds = true
    }
}
