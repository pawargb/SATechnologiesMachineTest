//
//  CoreDataManager.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 11/07/24.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var managedContext: NSManagedObjectContext?
    
    private init() {
        managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func retrieveData(entityName: String) -> [NSFetchRequestResult] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            if let result = try managedContext?.fetch(fetchRequest) {
                return result
            }
        } catch {
            print("Failed to retrieve data for : \(entityName)")
        }
        return []
    }
    
//    func createShopManagedObject() -> ShopEntity? {
//        if let mContext = managedContext {
//            return ShopEntity(context: mContext)
//        }
//        return nil
//    }
//    
//    func createProductManagedObject() -> ProductEntity? {
//        if let mContext = managedContext {
//            return ProductEntity(context: mContext)
//        }
//        return nil
//    }
//    
//    func deleteCart() {
//        if let shops = retrieveData(entityName: Constant.EntityName.ShopEntity) as? [ShopEntity] {
//            for shop in shops {
//                deleteManagedObject(object: shop)
//            }
//        }
//    }
    
    func deleteManagedObject(object :NSManagedObject) {
        if let mContext = managedContext {
            mContext.delete(object)
            saveContext()
        }
    }
    
    func saveContext() {
        do {
            try managedContext?.save()
        } catch {
            print("Error while saving context: \(error.localizedDescription)")
        }
    }
    
    func createData(entityName: String) -> NSManagedObject? {
        
        guard let context = managedContext,
              let userEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return nil}
        let user =  NSManagedObject(entity: userEntity, insertInto: managedContext)
        saveContext()
        return user
    }
}
