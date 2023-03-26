//
//  Contact+CoreDataProperties.swift
//  myContacts
//
//  Created by konstantine on 05.03.23.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String
    @NSManaged public var profilePicture: Data?
    @NSManaged public var surname: String?
    @NSManaged public var isFavorite: Bool

}

extension Contact : Identifiable {

}
