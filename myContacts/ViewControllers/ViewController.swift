//
//  ViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit
    // TODO: fix optional profile picture bug , add profile page and else 
class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables & Contstants
    var contacts = [Contact]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let refreshControll = UIRefreshControl()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllContact()
        tableView.reloadData()
        refreshControll.backgroundColor = UIColor.white
        refreshControll.tintColor = UIColor.orange
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
        getAllContact()
    }
    
    
    // MARK: - Methods
    
    @objc func refresh(){
        getAllContact()
        tableView.reloadData()
        refreshControll.endRefreshing()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsTableViewCell
        let contacts = contacts[indexPath.row]
        cell.nameLabel.text = contacts.name
        cell.surnameLabel.text = contacts.surname
        
        if contacts.profilePicture != nil {
            cell.profileImage?.image = UIImage(data: contacts.profilePicture!)
        } else {
            let avatar = UIImage(named: "avatar.png")
            let data = avatar?.pngData() as NSData?
            cell.profileImage?.image = UIImage(data: data! as Data)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contacts = contacts[indexPath.row]
        let alert = UIAlertController(title: "Delete", message: "Delete this Contact?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self]_ in
            self?.deleteContact(contact: contacts)
        }))
        
        present(alert, animated: true)
    }
}

    // MARK: - CRUD
extension ViewController {
    
    func getAllContact(){
        do{
            contacts = try context.fetch(Contact.fetchRequest())
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
        catch let error as NSError{
            print(error)
        }
        
    }
    
//    func newContact(name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?){
//        let newContact = Contact(context: context)
//        newContact.name = name
//        newContact.surname = surname
//        newContact.phoneNumber = phoneNumber
//        newContact.profilePicture = profilePicture
//
//        do{
//            try context.save()
//            getAllContact()
//        }
//        catch let error as NSError{
//            print(error)
//        }
//    }
    
    func deleteContact(contact: Contact){
        context.delete(contact)
        
        do{
            try context.save()
            getAllContact()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func updateContact(contact: Contact, newName: String?, newSurname: String?, newPhoneNumber: String?,                         newProfilePicture: Data?){
        contact.name = newName
        contact.surname = newSurname
        contact.phoneNumber = newPhoneNumber
        contact.profilePicture = newProfilePicture
        
        do{
            try context.save()
            getAllContact()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
}

