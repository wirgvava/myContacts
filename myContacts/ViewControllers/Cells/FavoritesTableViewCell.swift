//
//  FavoritesTableViewCell.swift
//  myContacts
//
//  Created by konstantine on 05.03.23.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func callAction(_ sender: Any) {
        
    }
}
