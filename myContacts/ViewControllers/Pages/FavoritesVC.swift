//
//  FavoritesVC.swift
//  myContacts
//
//  Created by konstantine on 04.03.23.
//

import UIKit
import CoreData

class FavoritesVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    let refreshControll = UIRefreshControl()
    var fetchedResultsController: NSFetchedResultsController<Contact>!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavoriteContacts()
        refreshControll.backgroundColor = UIColor.clear
        refreshControll.tintColor = UIColor.orange
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    @objc func refresh(){
        self.getFavoriteContacts()
        self.tableView.reloadData()
        refreshControll.endRefreshing()
    }
    
    func getFavoriteContacts(){
        if fetchedResultsController == nil {
            let request = Contact.createFetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            request.predicate = NSPredicate(format: "isFavorite == %@", "1")
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                self.tableView.reloadData()
                
            } catch {
                print("Fetch failed")
            }
        }
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
        let contacts = self.fetchedResultsController.object(at: indexPath)
        cell.surnameLabel.text = contacts.surname

        if contacts.name == "" && contacts.surname == "" {
            cell.nameLabel.text = contacts.phoneNumber
        } else {
            cell.nameLabel.text = contacts.name
        }
       
        if contacts.profilePicture != nil {
            cell.profilePicture?.image = UIImage(data: contacts.profilePicture!)
        } else {
            let name = contacts.name
            let surname = contacts.surname
            let firstLetterOfName = name?.prefix(1).uppercased()
            let firstLetterOfSurname = surname?.prefix(1).uppercased()
            let initials = "\(firstLetterOfName ?? "")\(firstLetterOfSurname ?? "")"
            let image = HomeVC.generateImageWithInitials(initials: initials)
            cell.profilePicture.image = image
        }
        return cell
    }
    
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
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            self.tableView.reloadData()

        case .insert:
            self.tableView.reloadData()
            
            
        default:
            break
        }
    }
}
