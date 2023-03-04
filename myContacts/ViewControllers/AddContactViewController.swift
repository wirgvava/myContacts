//
//  AddContactViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit
import Loaf

class AddContactViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addProfileImage: UIImageView!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!

    
    // MARK: - Variables & Constants
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imagePicker = UIImagePickerController()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        imagePicker.delegate = self
    }
    
    
    // MARK: - Actions
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        saveContactAction()
    }
    
    @IBAction func uploadPhotoAction(_ sender: UIButton) {
        uploadPhoto()
    }
    
    // MARK: - Methods
    private func uploadPhoto(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func saveContactAction(){
        if phoneNumberTextField.text != "" {
            DataBaseProperty.shared.newContact(name: (nameTextField.text) ?? "",
                                               surname: (lastNameTextField.text) ?? "",
                                               phoneNumber: phoneNumberTextField.text!,
                                               profilePicture: addProfileImage.image?.pngData())
            
            self.navigationController?.popViewController(animated: true)
        } else {
            Loaf("Phone number is missing.", state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
        
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

// Gesture to dismiss keyboard
extension AddContactViewController: UIGestureRecognizerDelegate {
    private func setupGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearchBar))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissSearchBar(){
       view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
