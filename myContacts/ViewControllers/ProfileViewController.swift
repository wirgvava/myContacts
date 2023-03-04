//
//  ProfileViewController.swift
//  myContacts
//
//  Created by konstantine on 05.02.23.
//

import UIKit
import MessageUI
import CoreData

class ProfileViewController: UIViewController {
    
    let vc = ViewController()
    let shared = DataBaseProperty.shared
    var imagePicker = UIImagePickerController()
    var data:(name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?)
    
    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var massageBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var editNameTextField: UITextField!            // Outlets for Edit page
    @IBOutlet weak var editLastnameTextField: UITextField!
    @IBOutlet weak var editPhoneNumberTextField: UITextField!
    @IBOutlet weak var editNameLabel: UILabel!
    @IBOutlet weak var editLastnameLabel: UILabel!
    @IBOutlet weak var editPhoneNumberLabel: UILabel!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        nameLabel.text = data.name
        surnameLabel.text = data.surname
        phoneNumberLabel.text = data.phoneNumber
        loadProfilePicture()
        loadEditPageAsHidden()
        imagePicker.delegate = self
        self.navigationController?.navigationBar.isHidden = true
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
        view.endEditing(true)
    }
    @IBAction func editAction(_ sender: UIButton) {
        editContact()
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        makeCall()
    }
    
    @IBAction func massageAction(_ sender: UIButton) {
        sendMessage()
    }
    
    @IBAction func uploadPhotoBtnTapped(_ sender: UIButton) {
        uploadPhoto()
    }
    
    
    
    // MARK: - Methods
    func set(data: (name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?)){
        self.data = data
    }
    
    private func loadProfilePicture(){
        if data.profilePicture != nil {
            profilePicture.image = UIImage(data: data.profilePicture!)
        } else {
            let name = data.name
            let surname = data.surname
            let firstLetterOfName = name?.prefix(1).uppercased()
            let firstLetterOfSurname = surname?.prefix(1).uppercased()
            let initials = "\(firstLetterOfName ?? "")\(firstLetterOfSurname ?? "")"
            let image = vc.generateImageWithInitials(initials: initials)
            profilePicture.image = image
        }
    }
    
    private func makeCall(){
        let phoneNumber = DataBaseProperty.shared.contacts.first?.phoneNumber
        if let phoneCallURL = URL(string: "tel://" + phoneNumber!) {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func editContact(){
        showEditPage()
        editNameTextField.text = nameLabel.text
        editLastnameTextField.text = surnameLabel.text
        editPhoneNumberTextField.text = phoneNumberLabel.text
    }
    
    private func save(){
        shared.updateContact(newName: editNameTextField.text,
                             newSurname: editLastnameTextField.text,
                             newPhoneNumber: editPhoneNumberTextField.text!,
                             newProfilePicture: profilePicture.image?.pngData())
        
        nameLabel.text = editNameTextField.text
        surnameLabel.text = editLastnameTextField.text
        phoneNumberLabel.text = editPhoneNumberTextField.text
        hideEditPage()
        
    }
    
    private func cancel(){
        hideEditPage()
    }
    
    
    private func uploadPhoto(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

// Gesture to dismiss keyboard after editing
extension ProfileViewController: UIGestureRecognizerDelegate {
    func setupGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
       view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}

// Massage
extension ProfileViewController: MFMessageComposeViewControllerDelegate {
        func sendMessage() {
            if MFMessageComposeViewController.canSendText() {
                var phoneNumber = ""
                phoneNumber += phoneNumberLabel.text ?? ""
                let messageVC = MFMessageComposeViewController()
                messageVC.recipients = [phoneNumber]
                messageVC.messageComposeDelegate = self
                self.present(messageVC, animated: true, completion: nil)
            } else {
                print("SMS services are not available.")
            }
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case .cancelled:
                print("Message cancelled.")
            case .sent:
                print("Message sent.")
            case .failed:
                print("Message failed to send.")
            @unknown default:
                print("Unknown error.")
            }
            controller.dismiss(animated: true, completion: nil)
        }
    

}

// ImagePicker delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePicture.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


// Show & Hide edit page
extension ProfileViewController {
    private func hideEditPage(){
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
    
    private func showEditPage(){
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
    }
    
    private func loadEditPageAsHidden(){
        uploadPhotoBtn.isHidden = true
        editNameLabel.isHidden = true
        editLastnameLabel.isHidden = true
        editPhoneNumberLabel.isHidden = true
        editNameTextField.isHidden = true
        editLastnameTextField.isHidden = true
        editPhoneNumberTextField.isHidden = true
        cancelBtn.isHidden = true
        saveBtn.isHidden = true
    }
}
