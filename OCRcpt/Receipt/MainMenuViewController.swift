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
import Firebase

class MainMenuViewController: UIViewController {
    
    @IBOutlet var itemListTableView: UITableView!
    @IBOutlet var continueButton: ContinueButton!
    
    var image: UIImage!
    
    var _items = [Item]()
    var items: [Item] {
        get {
            return _items
        } set(val) {
            _items = val
            continueButton.update(enabled: _items.count > 0)
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
        } else if segue.identifier == "peopleSelectSegue" {
            if let vc = segue.destination as? PersonListViewController {
                vc.items = self.items
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
        self.image = image
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        self.upload(filename: formatter.string(from: Date()))
        
        //Use self.image and send it to the URL request
    }
    
    func upload(filename: String){
        var fn = filename
        fn = "100"
        
        let imageData = self.image.pngData()
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.googleapis.com/upload/storage/v1/b/image_in_ocrcpt/o?uploadType=media&name=\(fn)")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        
        request.httpBody = imageData
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(String(describing: response))")
            self.download(filename: fn)
        })
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.download), userInfo: fn, repeats: false)
        
        
        task.resume()
        
    }
    
    func downloadFromCloud() {
        Storage
        let islandRef = storageRef.child("images/island.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
            }
        }
        
    }
    @objc func download(filename: String){
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.googleapis.com/storage/v1/b/text_out_ocrcpt/o/\(filename)?alt=media")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        //request.addValue("application/json", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(String(describing: response))")
        })
        
    }
 
}
