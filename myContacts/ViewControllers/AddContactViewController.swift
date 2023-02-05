//
//  AddContactViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit

class AddContactViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var addProfileImage: UIImageView!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // MARK: - Variables & Constants
    let vc = ViewController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imagePicker = UIImagePickerController()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }
    
    
    // MARK: - Actions
    @IBAction func saveContact(_ sender: UIBarButtonItem) {

        let newContact = Contact(context: context)
        newContact.name = (nameTextField.text) ?? ""
        newContact.surname = (lastNameTextField.text) ?? ""
        newContact.phoneNumber = (phoneNumberTextField.text) ?? ""
        newContact.profilePicture = addProfileImage.image?.pngData()
        
        do{
            try context.save()
            vc.getAllContact()
        }
        catch let error as NSError{
            print(error)
        }
       
    }
    
    @IBAction func uploadPhotoAction(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
//        addProfileImage.isHidden = true
    }
}

extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            addProfileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
