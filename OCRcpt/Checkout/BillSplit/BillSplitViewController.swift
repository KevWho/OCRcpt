//
//  BillSplitViewController.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/4/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class BillSplitViewController: UIViewController {

    @IBOutlet var itemsTableView: UITableView!
    @IBOutlet var payersCollectionView: UICollectionView!
    @IBOutlet var continueButton: ContinueButton!
    
    var items: [Item]!
    var payers: [Person]!
    
    var selected: Person?
    
    var _payments = [Int: [Person]]()
    var payments: [(Person, Float)] {
        get {
            let lst = [(Person, Float)]()
            let prices = [Int]()
            for (key, val) in _payments {
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedItemCell(_ sender: Any) {
        if let p = selected {
            if let gesture = sender as? UIGestureRecognizer {
                if let cell = gesture.view as? ItemPayersTableViewCell {
                    if !cell.people.contains(where: { (person) -> Bool in
                        person === p
                    }) {
                        cell.people.append(p)
                        if _payments.keys.contains(cell.tag) {
                            _payments[cell.tag]?.append(p)
                        } else {
                            _payments[cell.tag] = [p]
                        }
                    } else {
                        cell.people.removeAll { (person) -> Bool in
                            person === p
                        }
                        if _payments.keys.contains(cell.tag) {
                            _payments[cell.tag]?.removeAll(where: { (person) -> Bool in
                                person === p
                            })
                        }
                    }
                    continueButton.update(enabled: payments.count > 0)
                }
            }
        }
    }
    
}

extension BillSplitViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem]()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.payers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "payerCell", for: indexPath) as! PayerCollectionViewCell
        let payer = indexPath.row < payers.count ? payers[indexPath.row] : Person.you
        
        if let img = payer.image {
            cell.profileImg.image = img
        }
        cell.nameLabel.text = payer.name
        cell.payer = payer
        
        if let p = selected {
            if p === payer {
                cell.setSelected(true)
            } else {
                cell.setSelected(false)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.row < payers.count ? payers[indexPath.row] : Person.you
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selected = nil
        collectionView.reloadData()
    }
    
}

extension BillSplitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemPayerCell") as! ItemPayersTableViewCell
        let item = items[indexPath.row]
        
        cell.name.text = item.name
        cell.price.text = item.getPriceStr()
        cell.tag = indexPath.row
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedItemCell(_:)))
        gesture.cancelsTouchesInView = false
        cell.addGestureRecognizer(gesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
}
