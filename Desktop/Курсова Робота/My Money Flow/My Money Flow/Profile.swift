//
//  Profile.swift
//  My Money Flow
//
//  Created by Ostap Romaniv on 5/25/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import UIKit

class Profile: NSObject, NSCoding {
    let image: UIImage?
    let name: String?
    let surname: String?
    let numberOfPartners: Int?
    var balance: Decimal?
    
    init(image: UIImage?, name: String? = "", surname: String? = "", numberOfPartners: Int? = 0, balance: Decimal? = 0) {
        
        self.image = image
        self.name = name
        self.surname = surname
        self.numberOfPartners = numberOfPartners
        self.balance = balance
        
        super.init()
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchieveURL = DocumentsDirectory?.appendingPathComponent("profile")
    
    struct PropertyKey {
        static let imageKey = "image"
        static let nameKey = "name"
        static let surnameKey = "surname"
        static let numberOfPartnersKey = "numberOfPartners"
        static let balanceKey = "balance"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(PropertyKey.imageKey)
        aCoder.encode(PropertyKey.nameKey)
        aCoder.encode(PropertyKey.surnameKey)
        aCoder.encode(PropertyKey.numberOfPartnersKey)
        aCoder.encode(PropertyKey.balanceKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let image = aDecoder.decodeObject(forKey: PropertyKey.imageKey) as? UIImage
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as? String
        let surname = aDecoder.decodeObject(forKey: PropertyKey.surnameKey) as? String
        let numberOfPartners = aDecoder.decodeObject(forKey: PropertyKey.numberOfPartnersKey) as? Int
        let balance = aDecoder.decodeObject(forKey: PropertyKey.balanceKey) as? Decimal
        
        self.init(image: image, name: name, surname: surname, numberOfPartners: numberOfPartners, balance: balance)
    }
}

