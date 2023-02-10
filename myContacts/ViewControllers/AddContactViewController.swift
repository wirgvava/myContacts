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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imagePicker = UIImagePickerController()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        addProfileImage.layer.cornerRadius = 75
    }
    
    
    // MARK: - Actions
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        saveContactAction()
    }
    
    @IBAction func uploadPhotoAction(_ sender: UIButton) {
        uploadPhoto()
    }
    
    func uploadPhoto(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func saveContactAction(){
        DataBaseProperty.shared.newContact(name: (nameTextField.text) ?? "",
                                           surname: (lastNameTextField.text) ?? "",
                                           phoneNumber: phoneNumberTextField.text!,
                                           profilePicture: addProfileImage.image?.pngData())
        
        self.navigationController?.popViewController(animated: true)
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
