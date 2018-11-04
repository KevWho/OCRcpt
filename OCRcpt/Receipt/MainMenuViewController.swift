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
    @IBOutlet var continueButton: RoundedButton!
    
    var _items = [Item]()
    var items: [Item] {
        get {
            return _items
        } set(val) {
            _items = val
            continueButton.isEnabled = _items.count > 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemListTableView.reloadData()
    }
    
    @IBAction func tappedEdit(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: itemListTableView.isEditing ? .compose : .done, target: self, action: #selector(tappedEdit(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        itemListTableView.isEditing = !itemListTableView.isEditing
        itemListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scannerSegue" {
            if let vc = segue.destination as? ScannerViewController {
                vc.delegate = self
            }
        }
    }
    
}

extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + (tableView.isEditing ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEditing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newItemCell") as! NewItemTableViewCell
            cell.tag = indexPath.row
            cell.delegate = self
            
            if indexPath.row < items.count {
                cell.nameField.text = items[indexPath.row].name
                cell.priceField.text = items[indexPath.row].getPriceStr()
            } else {
                cell.nameField.text = ""
                cell.priceField.text = ""
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
            cell.tag = indexPath.row
            
            cell.name.text = items[indexPath.row].name
            cell.price.text = items[indexPath.row].getPriceStr()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row < items.count {
                items.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension MainMenuViewController: NewItemCellDelegate {
    
    func updateWith(item: Item, cell: NewItemTableViewCell) {
        if cell.tag < items.count {
            items[cell.tag] = item
        } else {
            items.append(item)
            itemListTableView.reloadData()
        }
    }
    
}


extension MainMenuViewController: ScannerViewDelegate {
    
    func useImage(_ image: UIImage!) {
        //Send to Corey's stuff
    }
    
}
