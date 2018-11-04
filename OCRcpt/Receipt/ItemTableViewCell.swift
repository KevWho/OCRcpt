//
//  ItemTableViewCell.swift
//  OCRcpt
//
//  Created by Corey Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
