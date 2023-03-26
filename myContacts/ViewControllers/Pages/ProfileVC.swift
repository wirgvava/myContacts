//
//  ProfileViewController.swift
//  myContacts
//
//  Created by konstantine on 05.02.23.
//

import UIKit
import MessageUI
import CoreData

class ProfileVC: UIViewController {
    
    var imagePicker = UIImagePickerController()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data:(name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?)
    var contactIndex: Int = 0
    let request = Contact.createFetchRequest()
    let sort =  NSSortDescriptor(key: "name", ascending: true)
    
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
    @IBOutlet weak var unselectedFavoriteBtn: UIButton!
    @IBOutlet weak var selectedFavoriteBtn: UIButton!
    @IBOutlet weak var editNameTextField: UITextField!            // Outlets for Edit page
    @IBOutlet weak var editLastnameTextField: UITextField!
    @IBOutlet weak var editPhoneNumberTextField: UITextField!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePage()
        setupGestures()
        loadProfilePicture()
        loadEditPageAsHidden()
        request.sortDescriptors = [sort]
        imagePicker.delegate = self
        editPhoneNumberTextField.delegate = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        hideEditPage()
        setProfilePage()
    }
    @IBAction func saveAction(_ sender: UIButton) {
        save()
    }
    @IBAction func editAction(_ sender: UIButton) {
        showEditPage()
        editNameTextField.text = nameLabel.text
        editLastnameTextField.text = surnameLabel.text
        editPhoneNumberTextField.text = phoneNumberLabel.text
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
    
    @IBAction func markAsFavoriteBtnTapped(_ sender: UIButton) {
        selectedFavoriteBtn.isHidden = false
        unselectedFavoriteBtn.isHidden = true
        addToFavorite(isFavorite: true)
    }
    
    @IBAction func markAsNonFavoriteBtnTapped(_ sender: UIButton) {
        selectedFavoriteBtn.isHidden = true
        unselectedFavoriteBtn.isHidden = false
        addToFavorite(isFavorite: false)
    }
    
    
    // MARK: - Methods
    func set(data: (name: String?, surname: String?, phoneNumber: String?, profilePicture: Data?)){
        self.data = data
    }
    
    private func setProfilePage(){
        nameLabel.text = data.name
        surnameLabel.text = data.surname
        phoneNumberLabel.text = data.phoneNumber
        
        do {
            let contact = try context.fetch(request)
            if contact[contactIndex].isFavorite == true {
                selectedFavoriteBtn.isHidden = false
                unselectedFavoriteBtn.isHidden = true
            } else {
                selectedFavoriteBtn.isHidden = true
                unselectedFavoriteBtn.isHidden = false
            }
        } catch let error as NSError {
            print(error)
        }
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
            let image = HomeVC.generateImageWithInitials(initials: initials)
            profilePicture.image = image
        }
    }
    
    private func save(){
        updateContact(newName: editNameTextField.text,
                      newSurname: editLastnameTextField.text,
                      newPhoneNumber: editPhoneNumberTextField.text!,
                      newProfilePicture: profilePicture.image?.pngData())
        
        nameLabel.text = editNameTextField.text
        surnameLabel.text = editLastnameTextField.text
        phoneNumberLabel.text = editPhoneNumberTextField.text
        hideEditPage()
        setProfilePage()
        view.endEditing(true)
    }
    
    private func uploadPhoto(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    private func addToFavorite(isFavorite: Bool){
        do {
            let contact = try! context.fetch(request)
            contact[contactIndex].isFavorite = isFavorite
            try context.save()
        }catch let error as NSError {
            print(error)
        }
    }
    
    
    private func updateContact(newName: String?, newSurname: String?, newPhoneNumber: String, newProfilePicture: Data?){
        do {
            let contact = try context.fetch(request)
            contact[contactIndex].name = newName
            contact[contactIndex].surname = newSurname
            contact[contactIndex].phoneNumber = newPhoneNumber
            contact[contactIndex].profilePicture = newProfilePicture
            delegate.saveContext()
        } catch let error as NSError{
            print("Error at updateContact(): \(error.localizedDescription)")
        }
    }
}

// Massage
extension ProfileVC: MFMessageComposeViewControllerDelegate {
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
    
    
    private func makeCall(){
        let contact = try! context.fetch(request)
        let phoneNumber = contact[contactIndex].phoneNumber
        if let phoneCallURL = URL(string: "tel://" + phoneNumber) {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    

}

// ImagePicker delegate
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePicture.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


// Gesture to dismiss keyboard after editing
extension ProfileVC: UIGestureRecognizerDelegate {
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


// textField
extension ProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = editPhoneNumberTextField.text ?? ""
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
        editPhoneNumberTextField.text = formattedText
        return false
    }
}



// Show & Hide edit page
extension ProfileVC {
    private func hideEditPage(){
        uploadPhotoBtn.isHidden = true
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
        selectedFavoriteBtn.isHidden = true
        unselectedFavoriteBtn.isHidden = true
    }
    
    private func loadEditPageAsHidden(){
        uploadPhotoBtn.isHidden = true
        editNameTextField.isHidden = true
        editLastnameTextField.isHidden = true
        editPhoneNumberTextField.isHidden = true
        cancelBtn.isHidden = true
        saveBtn.isHidden = true
    }
}
