//
//  Contact+CoreDataProperties.swift
//  myContacts
//
//  Created by konstantine on 12.04.23.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String
    @NSManaged public var profilePicture: Data?
    @NSManaged public var surname: String?

}

extension Contact : Identifiable {

}
