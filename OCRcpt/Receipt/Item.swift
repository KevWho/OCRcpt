//
//  Item.swift
//  OCRcpt
//
//  Created by Corey Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name: String!
    var price: Float!
    var unit: String?
    
    init(name: String!, price: Float!, unit: String?) {
        super.init()
        self.name = name
        self.price = price
        self.unit = unit
    }
    
    func getPriceStr() -> String! {
        if let sign = unit {
            return "\(sign)\(String(describing: price))"
        }
        return "\(String(describing: price))"
    }
}
