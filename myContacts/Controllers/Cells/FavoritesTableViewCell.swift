//
//  FavoritesTableViewCell.swift
//  myContacts
//
//  Created by konstantine on 05.03.23.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: - Variables & Constants
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contactIndex: Int = 0
    
    // MARK: - Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.applyshadowWithCorner(containerView: containerView, cornerRadious: profilePicture.frame.width / 2)
    }

    // MARK: - Actions
    @IBAction func callAction(_ sender: Any) {
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
            profilePicture?.image = UIImage(data: contacts.profilePicture!)
        } else {
            let name = contacts.name
            let surname = contacts.surname
            let firstLetterOfName = name?.prefix(1).uppercased()
            let firstLetterOfSurname = surname?.prefix(1).uppercased()
            let initials = "\(firstLetterOfName ?? "")\(firstLetterOfSurname ?? "")"
            let image = generateImageWithInitials(image: profilePicture, initials: initials)
            profilePicture.image = image
        }
    }
}
