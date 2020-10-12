//
//  NSManagedObjectContext+Additions.swift
//  
//
//  Created by Abdel Ali on 10/12/20.
//

import Foundation
import CoreData

public extension NSManagedObjectContext {

    func insertObject<A: NSManagedObject>() -> A where A: Manageable {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return entity
    }

    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}

