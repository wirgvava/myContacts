//
//  Contact+CoreDataProperties.swift
//  myContacts
//
//  Created by konstantine on 04.02.23.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profilePicture: Data?

}

extension Contact : Identifiable {

}
