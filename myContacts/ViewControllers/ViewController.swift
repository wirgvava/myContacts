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
    
    // Swipe to delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            showDeleteAlert(indexPath: indexPath)
        }
    }
    
    //Alert ^
    func showDeleteAlert(indexPath: IndexPath){
        let contacts = contacts[indexPath.row]
        let alert = UIAlertController(title: "Delete this number?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] handlerYes in
            deleteContact(contact: contacts)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
    // Navigation
extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= contacts.count - 1 {
            self.openProfileViewController(index: indexPath)
        }
    }
    
    func openProfileViewController (index: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        let profileInfo = contacts[index.row]
        
        vc.set(data: (name: profileInfo.name,
                      surname: profileInfo.surname,
                      phoneNumber: profileInfo.phoneNumber,
                      profilePicture: profileInfo.profilePicture))
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    func updateContact(contact: Contact, newName: String?, newSurname: String?, newPhoneNumber: String,                         newProfilePicture: Data?){
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

