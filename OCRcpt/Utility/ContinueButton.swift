//
//  ContinueButton.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/4/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class ContinueButton: RoundedButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        update(enabled: isEnabled)
    }
    
    func update(enabled: Bool) {
        isEnabled = enabled
        if isEnabled {
            self.backgroundColor = ColorUtil.color(.blue)
            self.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.backgroundColor = ColorUtil.color(.grey)
            self.setTitleColor(ColorUtil.color(.blue), for: .normal)
        }
    }
    
}
