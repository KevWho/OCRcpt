//
//  MenuNavigationController.swift
//  OCRcpt
//
//  Created by Corey Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit
import SideMenu

class MenuNavigationController: UISideMenuNavigationController {

    override func viewDidLoad() {
        SideMenuManager.default.menuLeftNavigationController = self
//        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationBar)
//        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view)
        
        SideMenuManager.default.menuFadeStatusBar = false
    }
}
