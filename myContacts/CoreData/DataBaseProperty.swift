//
//  DataBaseProperty.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import Foundation
import UIKit

class DataBaseProperty {
    
    static let shared = DataBaseProperty()
    
    var contacts = [Contact]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - CRUD
    func getAllContact(){
        do{
            contacts = try context.fetch(Contact.fetchRequest())
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func newContact(name: String?, surname: String?, phoneNumber: String, profilePicture: Data?){
        let newContact = Contact(context: context)
        newContact.name = name
        newContact.surname = surname
        newContact.phoneNumber = phoneNumber
        newContact.profilePicture = profilePicture
        
        do{
            try context.save()
            getAllContact()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func deleteContact(contact: Contact){
        context.delete(contact)
        
        do{
            try context.save()
            getAllContact()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func updateContact(contact: Contact, newName: String?, newSurname: String?, newPhoneNumber: String,                         newProfilePicture: Data?){
        contact.name = newName
        contact.surname = newSurname
        contact.phoneNumber = newPhoneNumber
        contact.profilePicture = newProfilePicture
        
        do{
            try context.save()
            getAllContact()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
}
