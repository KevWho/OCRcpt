//
//  NewItemTableViewCell.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

protocol NewItemCellDelegate {
    func updateWith(item: Item, cell: NewItemTableViewCell)
}

class NewItemTableViewCell: UITableViewCell {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    var delegate: NewItemCellDelegate?
    var modified = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func modifiedText(_ sender: Any) {
        modified = true
        
        if delegate != nil {
            let price = priceField.text!.count > 0 ? Float(priceField.text!) : 0
            delegate?.updateWith(item: Item(name: nameField.text, price: price, unit: nil), cell: self)
        }
    }
    
}
