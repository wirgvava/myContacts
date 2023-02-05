//
//  TableTableViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
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
        
    }
}
