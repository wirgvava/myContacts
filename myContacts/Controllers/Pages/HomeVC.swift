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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var contactsCountLabel: UILabel!
    @IBOutlet weak var showSearchBarBtn: UIButton!
    @IBOutlet weak var hideSearchBarBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variables & Contstants
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let refreshControll = UIRefreshControl()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultsController: NSFetchedResultsController<Contact>!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        searchBarSearchButtonClicked(searchBar)
        getAllData()
        setShadow()
        refreshControll.backgroundColor = UIColor.clear
        refreshControll.tintColor = UIColor.darkGray
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        navigationController?.navigationBar.isHidden = true
        overrideUserInterfaceStyle = .light
    }
    
    
    @IBAction func showSearchButtonAction(_ sender: UIButton) {
        titleLabel.isHidden = true
        searchBar.isHidden = false
        showSearchBarBtn.isHidden = true
        hideSearchBarBtn.isHidden = false
    }
    
    @IBAction func hideSearchBarButtonAction(_ sender: UIButton) {
        titleLabel.isHidden = false
        searchBar.isHidden = true
        showSearchBarBtn.isHidden = false
        hideSearchBarBtn.isHidden = true
    }
    
    // MARK: - Methods
    @objc func refresh(){
        getAllData()
        self.tableView.reloadData()
        refreshControll.endRefreshing()
    }
    
    private func getAllData(){
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
    
    private func setShadow(){
        addButton.layer.masksToBounds = false
        addButton.layer.cornerRadius = addButton.frame.height/2
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowPath = UIBezierPath(roundedRect: addButton.bounds, cornerRadius: addButton.layer.cornerRadius).cgPath
        addButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 3.0
    }
}



// MARK: - TableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsTableViewCell
        let contacts = self.fetchedResultsController.object(at: indexPath)
        cell.configure(contacts: contacts, contactIndex: indexPath.row)
        
        if self.fetchedResultsController.fetchedObjects?.count == 0 {
            contactsCountLabel.text = ""
        } else  if self.fetchedResultsController.fetchedObjects?.count == 1 {
            contactsCountLabel.text = "\(String(describing: self.fetchedResultsController.fetchedObjects!.count)) Contact"
        } else {
            contactsCountLabel.text = "\(String(describing: self.fetchedResultsController.fetchedObjects!.count)) Contacts"
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


// MARK: - Navigation
extension HomeVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileVC
        let profileInfo = self.fetchedResultsController.object(at: indexPath)
        vc.contactIndex = indexPath.row
        vc.set(data: (name: profileInfo.name, surname: profileInfo.surname, phoneNumber: profileInfo.phoneNumber, profilePicture: profileInfo.profilePicture))
        self.tableView.reloadData()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Search
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


// MARK: - Gesture to dismiss keyboard after Searching
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
