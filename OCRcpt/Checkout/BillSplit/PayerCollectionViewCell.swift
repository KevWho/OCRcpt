//
//  PayerCollectionViewCell.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/4/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class PayerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var payer: Person!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImg.layer.cornerRadius = self.profileImg.frame.height / 2
        self.profileImg.clipsToBounds = true
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            self.nameLabel.textColor = ColorUtil.color(.blue)
        } else {
            self.nameLabel.textColor = UIColor.black
        }
    }
    
}
