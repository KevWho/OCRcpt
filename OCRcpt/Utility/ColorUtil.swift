//
//  ColorUtil.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    case blue
    case grey
}

class ColorUtil: NSObject {
    
    static func color(_ color: Color) -> UIColor {
        switch color {
        case .blue:
            return UIColor(red: 32/255.0, green: 167/255.0, blue: 255/255.0, alpha: 1.0)
        case .grey:
            return UIColor(red: 243/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        }
    }
    
}
