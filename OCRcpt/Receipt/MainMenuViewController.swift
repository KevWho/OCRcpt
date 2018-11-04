//
//  MainMenu.swift
//  OCRcpt
//
//  Created by Corey Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class MainMenuViewController: UIViewController {
    
    @IBOutlet var itemListTableView: UITableView!
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
}

extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        
        cell.name.text = items[indexPath.row].name
        cell.price.text = items[indexPath.row].getPriceStr()
        
        return cell
    }
}
