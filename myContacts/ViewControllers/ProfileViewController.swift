//
//  ProfileViewController.swift
//  myContacts
//
//  Created by konstantine on 05.02.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    var data:(name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?)
    
    
    // MARK: - Outlets
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var massageBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var phoneNumberLabel: UILabel!
    // Outlets for Edit page
    @IBOutlet weak var editPhoneNumberTextField: UITextField!
    @IBOutlet weak var editLastnameTextField: UITextField!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editPhoneNumberLabel: UILabel!
    @IBOutlet weak var editLastnameLabel: UILabel!
    @IBOutlet weak var editNameLabel: UILabel!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = data.name
        surnameLabel.text = data.surname
        phoneNumberLabel.text = data.phoneNumber
//        profilePicture.image?.pngData() = NSData(data.profilePicture) as Data?
        
        if data.profilePicture != nil {
            profilePicture.image = UIImage(data: data.profilePicture!)
        } else {
            let avatar = UIImage(named: "avatar.png")
            let data = avatar?.pngData() as NSData?
            profilePicture.image = UIImage(data: data! as Data)
        }
        
        
        uploadPhotoBtn.isHidden = true
        editNameLabel.isHidden = true
        editLastnameLabel.isHidden = true
        editPhoneNumberLabel.isHidden = true
        editNameTextField.isHidden = true
        editLastnameTextField.isHidden = true
        editPhoneNumberTextField.isHidden = true
        myView.layer.cornerRadius = 20
        profilePicture.layer.cornerRadius = 75
    }
    
    
    
    
    
    
    // MARK: - Actions
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        uploadPhotoBtn.isHidden = false
        editNameLabel.isHidden = false
        editLastnameLabel.isHidden = false
        editPhoneNumberLabel.isHidden = false
        editNameTextField.isHidden = false
        editLastnameTextField.isHidden = false
        editPhoneNumberTextField.isHidden = false
        
        phoneNumberLabel.isHidden = true
        nameLabel.isHidden = true
        surnameLabel.isHidden = true
        callBtn.isHidden = true
        massageBtn.isHidden = true
        myView.isHidden = true
        editBtn.title = "Save"
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        
    }
    
    @IBAction func massageAction(_ sender: UIButton) {
    }
    
   
    func set(data: (name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?)){
        self.data = data
    }
    
}
