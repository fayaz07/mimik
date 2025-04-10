//
//  WorkspaceEntity+CoreDataProperties.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 31/03/25.
//
//

import Foundation
import CoreData


extension WorkspaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceEntity> {
        return NSFetchRequest<WorkspaceEntity>(entityName: "WorkspaceEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var deleted: Bool
    @NSManaged public var lastAccessed: Date?
    @NSManaged public var created: Date?

}

extension WorkspaceEntity : Identifiable {

}
