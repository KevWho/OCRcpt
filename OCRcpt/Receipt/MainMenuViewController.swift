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
import FirebaseStorage

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
        
        let imageData = self.image.jpegData(compressionQuality: 1.0)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.googleapis.com/upload/storage/v1/b/image_in_ocrcpt/o?uploadType=media&name=\(fn)")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        
        request.httpBody = imageData
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(String(describing: response))")
        })
        self.downloadFromCloud(filename: fn)
        
        task.resume()
        
    }
    
    func downloadFromCloud(filename: String) {
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let fileRef = storage.reference(forURL: "gs://ocrcpt-server.appspot.com/\(filename)_items.json")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        fileRef.getData(maxSize: 1 * 2056 * 2056) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                return
            } else {
                let json = try? JSONSerialization.jsonObject(with: data!)
                print(json as Any)
            }
        }

    }

}
