// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.swift instead.

import Foundation
import CoreData

public enum UserAttributes: String {
    case id = "id"
}

public enum UserRelationships: String {
    case locations = "locations"
}

open class _User: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "User"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _User.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var id: String?

    // MARK: - Relationships

    @NSManaged open
    var locations: NSSet

    open func locationsSet() -> NSMutableSet {
        return self.locations.mutableCopy() as! NSMutableSet
    }

}

