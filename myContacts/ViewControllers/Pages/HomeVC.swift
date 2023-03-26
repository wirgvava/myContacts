//
//  ViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit
import CoreData

class HomeVC: UIViewController, NSFetchedResultsControllerDelegate {
        
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactsCountLabel: UILabel!
    
    // MARK: - Variables & Contstants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let refreshControll = UIRefreshControl()
    var fetchedResultsController: NSFetchedResultsController<Contact>!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        searchBarSearchButtonClicked(searchBar)
        getAllData()
        refreshControll.backgroundColor = UIColor.clear
        refreshControll.tintColor = UIColor.orange
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
    }
    
    // MARK: - Methods
    
    @objc func refresh(){
        getAllData()
        self.tableView.reloadData()
        refreshControll.endRefreshing()
    }
    
    
    func getAllData(){
        if self.fetchedResultsController == nil{
            let request = Contact.createFetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            self.fetchedResultsController.delegate = self
            
            do{
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch let error as NSError {
                print("Error at getAllData(): \(error.localizedDescription)")
            }
        }
    }
}



// TableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fetchedResultsController.sections![section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsTableViewCell
        let contacts = self.fetchedResultsController.object(at: indexPath)
        cell.contactIndex = indexPath.row
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
            let image = HomeVC.generateImageWithInitials(initials: initials)
            cell.profileImage.image = image
        }
        
        if self.fetchedResultsController.fetchedObjects?.count == 0 {
            contactsCountLabel.text = ""
        } else  if self.fetchedResultsController.fetchedObjects?.count == 1 {
            contactsCountLabel.text = "\(String(describing: self.fetchedResultsController.fetchedObjects!.count)) Contact"
        } else {
            contactsCountLabel.text = "\(String(describing: self.fetchedResultsController.fetchedObjects!.count)) Contacts"
        }
       return cell
    }
    
    // Image with Initials if profile picture is not set
    static func generateImageWithInitials(initials: String) -> UIImage {
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
        let contacts = self.fetchedResultsController.object(at: indexPath)
        let alert = UIAlertController(title: "Delete this number?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] handlerYes in
            context.delete(contacts)
            delegate.saveContext()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            self.tableView.reloadData()
            
        case .insert:
            self.tableView.reloadData()
            
        case .update:
            self.tableView.reloadData()
        default:
            break
        }
    }
}


// Navigation
extension HomeVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileVC
        let profileInfo = self.fetchedResultsController.object(at: indexPath)
        vc.contactIndex = indexPath.row
        vc.set(data: (name: profileInfo.name,
                      surname: profileInfo.surname,
                      phoneNumber: profileInfo.phoneNumber,
                      profilePicture: profileInfo.profilePicture))
        self.tableView.reloadData()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


// Search
extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        
        try? fetchedResultsController.performFetch()
        self.tableView.reloadData()
    }
    
    
}


// Gesture to dismiss keyboard after Searching
extension HomeVC: UIGestureRecognizerDelegate {
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
