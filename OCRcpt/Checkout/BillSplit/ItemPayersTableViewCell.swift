//
//  ItemPayersTableViewCell.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/4/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class ItemPayersTableViewCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var payers: UILabel!
    @IBOutlet var price: UILabel!
    
    var _people = [Person]()
    var people: [Person] {
        get {
            return _people
        } set(val) {
            _people = val
            if _people.count > 0 {
                let str = _people[1..<_people.count].reduce(_people[0].name, { (x, y) -> String in
                    x + " and " +  y.name
                })
                payers.text = str + " are paying"
            } else {
                payers.text = "0 people paying"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
