//
//  DatabaseManager.swift
//  CodableSample
//
//  Created by Aina Jain on 12/03/19.
//  Copyright © 2019 Aina Jain. All rights reserved.
//
import UIKit
import CoreData

class DatabaseManager : NSObject {
    
    static let shared = DatabaseManager()
    
    private override init() {}
    
    func getNewContext() -> NSManagedObjectContext? {
        let newContext = self.persistentContainer.viewContext
        return newContext
    }
    
    func addRecordToTableInfo(withRecord record: TableModel) {
        if let context = getNewContext() {
            if let entity = NSEntityDescription.entity(forEntityName: "TableInfo", in: context) {
                if let object = NSManagedObject(entity: entity, insertInto: context) as? TableInfo {
                    object.title = record.title
                    object.url = record.url?.absoluteString
                    object.youTubeId = record.youTubeId
                }
                
            }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func getRecordFromTableInfo() -> [TableModel]? {
        var modelArray = [TableModel]()
        if let context = getNewContext() {
            let request = NSFetchRequest<TableInfo>(entityName: "TableInfo")
            request.returnsObjectsAsFaults = false
            do{
                let result = try context.fetch(request)
                for record in result {
                    let modelRecord = TableModel()
                    modelRecord.title = record.title
                    modelRecord.url = URL(string: record.url!)
                    modelRecord.youTubeId = record.youTubeId
                    modelRecord.imagePath = record.imagePath
                    modelArray.append(modelRecord)
                }
            }catch{
                print("Fetch Failed")
            }
        }
        return modelArray
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CodableSample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}
