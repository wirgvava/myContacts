//
//  TableTableViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    fileprivate var applicaton = UIApplication.shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = 25
    }
    
    // MARK: - Actions
    @IBAction func callAction(_ sender: UIButton) {
        let phoneNumber = DataBaseProperty.shared.contacts.first?.phoneNumber
        if let phoneCallURL = URL(string: "tel://" + phoneNumber!) {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}
