//
//  ViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit

class ViewController: UIViewController {
        
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables & Contstants
    let refreshControll = UIRefreshControl()
    let contact = Contact(context: DataBaseProperty.shared.context)
    var contactsArray: [Contact] = []
    var filteredConstacts: [Contact] = []
    

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        DataBaseProperty.shared.getAllContact()
        refreshControll.backgroundColor = UIColor.white
        refreshControll.tintColor = UIColor.orange
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        tableView.reloadData()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    
    // MARK: - Methods
    
    @objc func refresh(){
        DataBaseProperty.shared.getAllContact()
        tableView.reloadData()
        refreshControll.endRefreshing()
    }
   
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBaseProperty.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsTableViewCell
        let contacts = DataBaseProperty.shared.contacts[indexPath.row]
        cell.nameLabel.text = contacts.name
        cell.surnameLabel.text = contacts.surname
        cell.phoneNumber = contacts.phoneNumber
        
        if contacts.profilePicture != nil {
            cell.profileImage?.image = UIImage(data: contacts.profilePicture!)
        } else {
            let avatar = UIImage(named: "avatar.png")
            let data = avatar?.pngData() as NSData?
            cell.profileImage?.image = UIImage(data: data! as Data)
        }
        
        return cell
    }
    
    // Swipe to delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            showDeleteAlert(indexPath: indexPath)
        }
    }
    
    //Alert ^
    func showDeleteAlert(indexPath: IndexPath){
        let contacts = DataBaseProperty.shared.contacts[indexPath.row]
        let alert = UIAlertController(title: "Delete this number?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] handlerYes in
            DataBaseProperty.shared.deleteContact(contact: contacts)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
    // Navigation
extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= DataBaseProperty.shared.contacts.count - 1 {
            self.openProfileViewController(index: indexPath)
        }
    }
    
    func openProfileViewController (index: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        let profileInfo = DataBaseProperty.shared.contacts[index.row]
  
        vc.set(data: (name: profileInfo.name,
                      surname: profileInfo.surname,
                      phoneNumber: profileInfo.phoneNumber,
                      profilePicture: profileInfo.profilePicture))
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContacts(text: searchController.searchBar.text!)
        
        func reloadData(){
            if searchController.isActive && searchController.searchBar.text != ""{
                DataBaseProperty.shared.contacts = filteredConstacts
            } else {
                DataBaseProperty.shared.contacts = contactsArray
            }
            tableView.reloadData()
        }
        
        
        func filterContacts(text: String, scope: String = "All") {
            filteredConstacts = DataBaseProperty.shared.contacts.filter({ (contact) -> Bool in
                let fullName = "\(contact.name?.lowercased() ?? "") \(contact.surname?.lowercased() ?? "")"
                return fullName.contains(text.lowercased())
            })
            
            self.tableView.reloadData()
        }
    }
}

