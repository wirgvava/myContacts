//
//  AddContactViewController.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import UIKit
import Loaf

class AddContactVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addProfileImage: UIImageView!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    
    // MARK: - Variables & Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imagePicker = UIImagePickerController()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        imagePicker.delegate = self
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        uploadPhotoBtn.layer.cornerRadius = uploadPhotoBtn.frame.height / 2
        navigationController?.navigationBar.isHidden = false
        overrideUserInterfaceStyle = .light
    }
    
    
    // MARK: - Actions
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        saveContactAction()
        navigationController?.navigationBar.isHidden = true
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
            newContact(name: (nameTextField.text) ?? "", surname: (lastNameTextField.text) ?? "",
                       phoneNumber: phoneNumberTextField.text!, profilePicture: addProfileImage.image?.pngData())
            
        self.navigationController?.popViewController(animated: true)
        } else {
            let error = "Phone number is missing."
            Loaf(error, state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    private func newContact(name: String?, surname: String?, phoneNumber: String, profilePicture: Data?){
        let newContact = Contact(context: context)
        newContact.name = name
        newContact.surname = surname
        newContact.phoneNumber = phoneNumber
        newContact.profilePicture = profilePicture
        delegate.saveContext()
    }
}

// MARK: - TextFieldDelegate
extension AddContactVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = phoneNumberTextField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let numericText = updatedText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var formattedText = ""
        let length = numericText.count
        
        for i in 0..<length {
            if i == 3 || i == 6 {
                formattedText += "-"
            }
            let index = numericText.index(numericText.startIndex, offsetBy: i)
            let character = numericText[index]
            formattedText += String(character)
        }
        phoneNumberTextField.text = formattedText
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.frame.origin.y = view.frame.origin.y - 130
    }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.frame.origin.y = view.frame.origin.y + 130
    }
}

// MARK: - ImagePickerController
extension AddContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            addProfileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Gesture to dismiss keyboard
extension AddContactVC: UIGestureRecognizerDelegate {
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
