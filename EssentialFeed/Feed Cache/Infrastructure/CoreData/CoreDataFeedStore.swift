//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    
    public static let modelName = "FeedStore"
    public static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    public struct ModelNotFound: Error {
        public let modelName: String
    }

    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataFeedStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

	public func retrieve(completion: @escaping RetrievalCompletion) {
		perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    return CacheFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
		}
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
            })
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		perform { context in
            completion(Result {
				try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
		}
	}

	func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
		let context = self.context
		context.perform { action(context) }
	}
}
