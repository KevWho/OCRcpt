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
    
    var items: [Item]!
    var payers: [Person]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension BillSplitViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.payers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}

extension BillSplitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
