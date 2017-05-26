//
//  TheReportNote.swift
//  My Money Flow
//
//  Created by Marta Romaniv on 06.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit

class TheReportNote: NSObject, NSCoding {
    let date: Date?
    let sum: Decimal?
    
    init(date: Date? = nil, sum: Decimal? = nil) {
        self.date = date
        self.sum = sum
        
        super.init()
    }
    
    
    // MARK: NSCoding Protocol:
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchieveURL = DocumentsDirectory?.appendingPathComponent("notes")

    struct PropertyKey {
        static let dateKey = "date"
        static let sumKey = "sum"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(PropertyKey.dateKey)
        aCoder.encode(PropertyKey.sumKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as? Date
        let sum = aDecoder.decodeObject(forKey: PropertyKey.sumKey) as? Decimal
        
        self.init(date: date, sum: sum)
    }

    static func balance( array: inout [TheReportNote]) -> Decimal? {
        var sum: Decimal = 0
        
        for i in array {
            if let summ = i.sum {
                
                sum += summ
            }
        }
        return sum
    }

}
