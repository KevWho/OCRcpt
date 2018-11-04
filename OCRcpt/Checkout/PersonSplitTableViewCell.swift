//
//  PersonSplitTableViewCell.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class PersonSplitTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var person: Person!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        profileImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.contentView.backgroundColor = ColorUtil.color(.blue)
            self.nameLabel.textColor = UIColor.white
        } else {
            self.contentView.backgroundColor = UIColor.clear
            self.nameLabel.textColor = UIColor.black
        }
        
        person.selected = selected
    }

}
