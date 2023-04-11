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
            let image = ContactsTableViewCell.generateImageWithInitials(image: profileImage, initials: initials)
            profileImage.image = image
        }
    }
    
    static func generateImageWithInitials(image: UIImageView ,initials: String) -> UIImage {
        let width = image.frame.width
        let height = image.frame.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = frame.size.width / 2
        imageView.layer.backgroundColor = CGColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        let initialsLabel = UILabel(frame: frame)
        initialsLabel.text = initials
        initialsLabel.textAlignment = .center
        initialsLabel.textColor = UIColor.white
        initialsLabel.font = UIFont.systemFont(ofSize: height / 2)
        imageView.addSubview(initialsLabel)
        return imageView.asImage()
    }
}
