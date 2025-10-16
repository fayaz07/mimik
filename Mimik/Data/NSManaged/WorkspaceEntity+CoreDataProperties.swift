//
//  WorkspaceEntity+CoreDataProperties.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 06/10/25.
//
//

public import Foundation
public import CoreData


public typealias WorkspaceEntityCoreDataPropertiesSet = NSSet

extension WorkspaceEntity {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceEntity> {
    return NSFetchRequest<WorkspaceEntity>(entityName: "WorkspaceEntity")
  }

  @NSManaged public var desc: String
  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var lastAccessed: Date?

}

extension WorkspaceEntity : Identifiable {
  func toDTO() -> WorkspaceDTO {
    WorkspaceDTO(
      id: self.id,
      name: self.name,
      desc: self.desc,
      lastAccessed: self.lastAccessed ?? Date()
    )
  }
}
