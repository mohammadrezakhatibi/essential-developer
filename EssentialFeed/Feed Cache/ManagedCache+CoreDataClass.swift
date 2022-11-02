//
//  ManagedCache+CoreDataClass.swift
//  EssentialFeed
//
//  Created by mohammadreza on 11/2/22.
//
//

import Foundation
import CoreData


public class ManagedCache: NSManagedObject {
    @NSManaged public var timestamp: Date
    @NSManaged public var feed: NSOrderedSet
}
