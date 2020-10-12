import Foundation
import CoreData

final public class NSManagedObjectObserver {

    enum ChangeType {
        case delete
        case update
    }

    fileprivate var token: NSObjectProtocol!

    init?(object: NSManagedObject, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else { return nil }
        token = moc.addObjectsDidChangeNotificationObserver { [weak self] note in
            guard let changeType = self?.changeType(of: object, in: note) else { return }
            changeHandler(changeType)
        }
    }

    deinit {
        if let t = token {
            NotificationCenter.default.removeObserver(t)
        }
    }

    fileprivate func changeType(of object: NSManagedObject, in note: ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || deleted.contains(object) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if updated.contains(object) {
            return .update
        }
        return nil
    }
}

