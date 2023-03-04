//
//  ViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
        
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactsCountLabel: UILabel!
    
    // MARK: - Variables & Contstants
    let refreshControll = UIRefreshControl()
    var contacts: [Contact] = []
    var searchText = ""{
        didSet{
            filterDataName()
        }
    }
    

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        searchBarSearchButtonClicked(searchBar)
        DataBaseProperty.shared.getAllContact()
        refreshControll.backgroundColor = UIColor.clear
        refreshControll.tintColor = UIColor.orange
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.reloadData()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.reloadData()
    }
    
    
    // MARK: - Methods
    
    @objc func refresh(){
        DataBaseProperty.shared.getAllContact()
        self.reloadData()
        refreshControll.endRefreshing()
    }
    
    func filterDataName () {
        DataBaseProperty.shared.filteredContacts = DataBaseProperty.shared.contacts.filter { value in
            let nameMatch = value.name?.range(of: searchText, options: .caseInsensitive)
            let surnameMatch = value.surname?.range(of: searchText, options: .caseInsensitive)
            let phoneNumberMatch = value.phoneNumber.range(of: searchText, options: .caseInsensitive)

            return nameMatch != nil || surnameMatch != nil || phoneNumberMatch != nil
        }
        self.reloadData()
    }
    
    func reloadData(){
        if searchText != "" {
            self.contacts = DataBaseProperty.shared.filteredContacts
        } else {
            self.contacts = DataBaseProperty.shared.contacts
        }
        tableView.reloadData()
    }
    
    
}

// TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsTableViewCell
        let contacts = self.contacts[indexPath.row]
        
        cell.surnameLabel.text = contacts.surname

        if contacts.name == "" && contacts.surname == "" {
            cell.nameLabel.text = contacts.phoneNumber
        } else {
            cell.nameLabel.text = contacts.name
        }
        
       
        if contacts.profilePicture != nil {
            cell.profileImage?.image = UIImage(data: contacts.profilePicture!)
        } else {
            let name = contacts.name
            let surname = contacts.surname
            let firstLetterOfName = name?.prefix(1).uppercased()
            let firstLetterOfSurname = surname?.prefix(1).uppercased()
            let initials = "\(firstLetterOfName ?? "")\(firstLetterOfSurname ?? "")"
            let image = generateImageWithInitials(initials: initials)
            cell.profileImage.image = image
        }
        
        if self.contacts.count == 0 {
            contactsCountLabel.text = ""
        } else  if self.contacts.count == 1 {
            contactsCountLabel.text = "\(self.contacts.count) Contact"
        } else {
            contactsCountLabel.text = "\(self.contacts.count) Contacts"
        }
        
       return cell
    }
    
    // Image with Initials if profile picture is not set
    func generateImageWithInitials(initials: String) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.gray.cgColor, UIColor.gray.cgColor]
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = frame.size.width / 2
        imageView.layer.addSublayer(gradientLayer)
        let initialsLabel = UILabel(frame: frame)
        initialsLabel.text = initials
        initialsLabel.textAlignment = .center
        initialsLabel.textColor = UIColor.white
        initialsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        imageView.addSubview(initialsLabel)
        return imageView.asImage()
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
            self.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}


// Navigation
extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= self.contacts.count - 1 {
            self.openProfileViewController(index: indexPath)
        }
    }
    
    func openProfileViewController (index: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        let profileInfo = self.contacts[index.row]
  
        vc.set(data: (name: profileInfo.name,
                      surname: profileInfo.surname,
                      phoneNumber: profileInfo.phoneNumber,
                      profilePicture: profileInfo.profilePicture))
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


// Search
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}



// Gesture to dismiss keyboard after Searching
extension ViewController: UIGestureRecognizerDelegate {
    func setupGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.tableView
    }
    
  
    func tableViewDidScroll(_ tableView: UITableView) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
