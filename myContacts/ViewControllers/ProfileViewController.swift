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
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var myView: UIView!
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
        
        if data.profilePicture != nil {
            profilePicture.image = UIImage(data: data.profilePicture!)
        } else {
            let avatar = UIImage(named: "avatar.png")
            let data = avatar?.pngData() as NSData?
            profilePicture.image = UIImage(data: data! as Data)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        uploadPhotoBtn.isHidden = true
        editNameLabel.isHidden = true
        editLastnameLabel.isHidden = true
        editPhoneNumberLabel.isHidden = true
        editNameTextField.isHidden = true
        editLastnameTextField.isHidden = true
        editPhoneNumberTextField.isHidden = true
        cancelBtn.isHidden = true
        saveBtn.isHidden = true
        myView.layer.cornerRadius = 20
        profilePicture.layer.cornerRadius = 75
    }
    
    
    
    
    
    
    // MARK: - Actions
   
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        cancel()
    }
    @IBAction func saveAction(_ sender: UIButton) {
        save()
    }
    @IBAction func editAction(_ sender: UIButton) {
        editContact()
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        
    }
    
    @IBAction func massageAction(_ sender: UIButton) {
        
    }
    
   
    func set(data: (name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?)){
        self.data = data
    }
    
    func editContact(){
        uploadPhotoBtn.isHidden = false
        editNameLabel.isHidden = false
        editLastnameLabel.isHidden = false
        editPhoneNumberLabel.isHidden = false
        editNameTextField.isHidden = false
        editLastnameTextField.isHidden = false
        editPhoneNumberTextField.isHidden = false
        cancelBtn.isHidden = false
        saveBtn.isHidden = false
        phoneNumberLabel.isHidden = true
        nameLabel.isHidden = true
        surnameLabel.isHidden = true
        callBtn.isHidden = true
        massageBtn.isHidden = true
        myView.isHidden = true
        backBtn.isHidden = true
        editBtn.isHidden = true
        
        editNameTextField.text = nameLabel.text
        editLastnameTextField.text = surnameLabel.text
        editPhoneNumberTextField.text = phoneNumberLabel.text
    }
    
    func save(){
        DataBaseProperty.shared.updateContact(contact: Contact(context: DataBaseProperty.shared.context),
                                              newName: (editNameTextField.text) ?? "",
                                              newSurname: (editLastnameTextField.text) ?? "",
                                              newPhoneNumber: editPhoneNumberTextField.text!,
                                              newProfilePicture: profilePicture.image?.pngData())
        
        
        uploadPhotoBtn.isHidden = true
        editNameLabel.isHidden = true
        editLastnameLabel.isHidden = true
        editPhoneNumberLabel.isHidden = true
        editNameTextField.isHidden = true
        editLastnameTextField.isHidden = true
        editPhoneNumberTextField.isHidden = true
        cancelBtn.isHidden = true
        saveBtn.isHidden = true
        phoneNumberLabel.isHidden = false
        nameLabel.isHidden = false
        surnameLabel.isHidden = false
        callBtn.isHidden = false
        massageBtn.isHidden = false
        myView.isHidden = false
        backBtn.isHidden = false
        editBtn.isHidden = false
    }
    
    func cancel(){
        uploadPhotoBtn.isHidden = true
        editNameLabel.isHidden = true
        editLastnameLabel.isHidden = true
        editPhoneNumberLabel.isHidden = true
        editNameTextField.isHidden = true
        editLastnameTextField.isHidden = true
        editPhoneNumberTextField.isHidden = true
        cancelBtn.isHidden = true
        saveBtn.isHidden = true
        phoneNumberLabel.isHidden = false
        nameLabel.isHidden = false
        surnameLabel.isHidden = false
        callBtn.isHidden = false
        massageBtn.isHidden = false
        myView.isHidden = false
        backBtn.isHidden = false
        editBtn.isHidden = false
    }
    
}
