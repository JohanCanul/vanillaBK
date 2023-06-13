//
//  UserController.swift
//  vanillaBK
//
//  Created by imac_01 on 01/06/23.
//

import Foundation
import CoreData

class UserController{
    static let shared = UserController()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores{
            storeDescription, error in
            if let error {
                print("Ocurrio un error", error.localizedDescription)
            }
        }
    }
    
    // CRUD CORE DATA
    func saveChanges(){
        let context = container.viewContext
        if context.hasChanges{
            do {
                try context.save()
            }
            catch{
                print("No se pudo actualizar", error.localizedDescription)
            }
        }
    }
    
    func read() -> [UserEntity] {
        var results: [UserEntity] = []
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        
        do{
            results = try container.viewContext.fetch(request)
        } catch {
            print("No se obtuvo informacion", error.localizedDescription)
        }
        
        return results
    }
    
    func create(username: String, password : String) {
        let entity = UserEntity(context: container.viewContext)
        
        entity.id = UUID()
        entity.password = password
        entity.username = username
        
        saveChanges()
    }
    
    func update(entity: UserEntity, username: String? = nil, password: String? = nil){
        var hasChanges: Bool = false
        
        if (username != nil) {
            entity.username = username
            hasChanges = true
        }
        
        if (password != nil) {
            entity.password = password
            hasChanges = true
        }
        
        if hasChanges{
            saveChanges()
        }
    }
    
    func delete(entity: UserEntity){
        container.viewContext.delete(entity)
        saveChanges()
    }
}
