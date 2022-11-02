//
//  ManagedFeedImage+CoreDataClass.swift
//  EssentialFeed
//
//  Created by mohammadreza on 11/2/22.
//
//

import Foundation
import CoreData


public class ManagedFeedImage: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var imageDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var url: URL
    @NSManaged public var cache: ManagedCache
}
