//
//  TableTableViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contactIndex: Int = 0
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Actions
    @IBAction func callAction(_ sender: UIButton) {
        let request = Contact.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        let contact = try! context.fetch(request)
        let phoneNumber = contact[contactIndex].phoneNumber
        if let phoneCallURL = URL(string: "tel://" + phoneNumber) {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}
