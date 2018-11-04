//
//  RoundedButton.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
    }

}
