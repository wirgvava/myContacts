//
//  DataBaseProperty.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//

import Foundation
import UIKit
import CoreData

class DataBaseProperty {
    
    static let shared = DataBaseProperty()
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
  
    
    // MARK: - CRUD
//    func newContact(name: String?, surname: String?, phoneNumber: String, profilePicture: Data?){
//        let newContact = Contact(context: context)
//        newContact.name = name
//        newContact.surname = surname
//        newContact.phoneNumber = phoneNumber
//        newContact.profilePicture = profilePicture
//        saveContext()
//    }
    
//    func deleteContact(contact: Contact){
//        context.delete(contact)
//        saveContext()
//    }
}
