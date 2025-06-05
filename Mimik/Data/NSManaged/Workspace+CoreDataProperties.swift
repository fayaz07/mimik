//
//  Workspace+CoreDataProperties.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 26/05/25.
//
//

import Foundation
import CoreData


extension Workspace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workspace> {
        return NSFetchRequest<Workspace>(entityName: "Workspace")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String

}

extension Workspace : Identifiable {

}
