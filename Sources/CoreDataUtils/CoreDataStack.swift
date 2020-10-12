import Foundation
import CoreData

public class CoreDataStack {

    private let dataModel: String
    private let storeType: String

    public lazy var persistentContainer: NSPersistentContainer! = {
        let persistentContainer = NSPersistentContainer(name: self.dataModel)
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = storeType

        return persistentContainer
    }()

    public lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }()

    public lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true

        return context
    }()

    public init(dataModel: String, storeType: String = NSSQLiteStoreType) {
        self.dataModel = dataModel
        self.storeType = storeType
    }

    public func setup(completion: (() -> Void)?) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }

            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
