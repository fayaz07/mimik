//
//  WorkspaceEntity+CoreDataProperties.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//
//

import Foundation
import CoreData


extension WorkspaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceEntity> {
        return NSFetchRequest<WorkspaceEntity>(entityName: "WorkspaceEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var desc: String?

}

extension WorkspaceEntity : Identifiable {

}
