//
//  TableTableViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contactIndex: Int = 0
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.applyshadowWithCorner(containerView: containerView, cornerRadious: profileImage.frame.width / 2)
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
    
    // MARK: - Methods
    func configure(contacts: Contact, contactIndex: Int){
        self.contactIndex = contactIndex
        surnameLabel.text = contacts.surname

        if contacts.name == "" && contacts.surname == "" {
            nameLabel.text = contacts.phoneNumber
        } else {
            nameLabel.text = contacts.name
        }
        
       
        if contacts.profilePicture != nil {
            profileImage?.image = UIImage(data: contacts.profilePicture!)
        } else {
            let name = contacts.name
            let surname = contacts.surname
            let firstLetterOfName = name?.prefix(1).uppercased()
            let firstLetterOfSurname = surname?.prefix(1).uppercased()
            let initials = "\(firstLetterOfName ?? "")\(firstLetterOfSurname ?? "")"
            let image = generateImageWithInitials(image: profileImage, initials: initials)
            profileImage.image = image
        }
    }
}
