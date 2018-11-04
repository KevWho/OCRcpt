//
//  PersonListViewController.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit

class PersonListViewController: UIViewController {

    @IBOutlet var personTableView: UITableView!
    @IBOutlet var continueButton: ContinueButton!
    
    var searchBar: UISearchBar!
    var filter: String?
    
    var items: [Item]!
    
    var data = [ ("Favorites", PersonDataStore.shared.favoritedPersons),
                 ("Other", PersonDataStore.shared.nonfavoritedPersons) ]
    var persons: [(String, [Person])] {
        get {
            if filter == nil || filter?.count == 0 {
                return data
            }
            
            var lst = [(String, [Person])]()
            for (s, p) in data {
                lst.append((s, p.filter({ (person) -> Bool in
                    person.name.lowercased().contains(filter!.lowercased())
                })))
            }
            return lst
        }
    }
    var selectedPersons: [Person] {
        get {
            var lst = [Person]()
            for (_, p) in data {
                lst.append(contentsOf: p.filter({ (person) -> Bool in
                    person.selected
                }))
            }
            return lst
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Name"
        navigationItem.titleView = searchBar
        searchBar.sizeToFit()
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "billSplitSegue" {
            if let vc = segue.destination as? BillSplitViewController {
                vc.items = self.items
                vc.payers = self.selectedPersons
            }
        }
    }
}

extension PersonListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonSplitTableViewCell
        let person = persons[indexPath.section].1[indexPath.row]
        
        if let img = person.image {
            cell.profileImg.image = img
        }
        cell.nameLabel.text = person.name
        cell.person = person
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personHeader") as! PersonHeaderTableViewCell
        
        cell.title.text = persons[section].0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        continueButton.update(enabled: selectedPersons.count > 0)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        continueButton.update(enabled: selectedPersons.count > 0)
    }
    
}

extension PersonListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter = searchText
        personTableView.reloadData()
    }
    
}
