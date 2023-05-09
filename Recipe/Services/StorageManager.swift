//
//  StorageManager.swift
//  Recipe
//
//  Created by Eugene on 8.04.23.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    
    private let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataStorage")

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
//    var viewContext: NSManagedObjectContext {
//        Self.persistentContainer.viewContext
//    }
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD Category
    
    func create(_ name: String, completion: (Category) -> Void) {
        
        let category = Category(context: viewContext)
        
        category.name = name
        
        completion(category)
        
        saveContext()
    }

    func fetchData(completion: (Result<[Category], Error>) -> Void) {
        
        let fetchRequest = Category.fetchRequest()

        do {
            let categories = try viewContext.fetch(fetchRequest)
            
            completion(.success(categories))
        } catch let error {
            completion(.failure(error))
        }
    }

    func update(_ category: Category, newName: String) {
        
        category.name = newName
        
        saveContext()
    }

    func delete<T: NSManagedObject>(_ attribute: T) {
        
        viewContext.delete(attribute)
        
        saveContext()
    }
}

// MARK: - CRUD Recipe

extension StorageManager {
    
    func create(_ newRecipe: RecipeModel, completion: (Recipe) -> Void) {
        
        let recipe = Recipe(context: viewContext)
        
        recipe.category = newRecipe.category
        recipe.name = newRecipe.name
        recipe.source = newRecipe.source
        recipe.notes = newRecipe.notes
        recipe.ingredients = newRecipe.ingredients
        recipe.directions = newRecipe.directions
        
        newRecipe.category.addToRecipes(recipe)
        
        completion(recipe)
        
        saveContext()
    }
    
    func fetchData(with name: String, completion: (Result<[Recipe], Error>) -> Void) {
        
        let fetchRequest = Recipe.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "category.name == %@", name)

        do {
            let recipes = try viewContext.fetch(fetchRequest)
            
            completion(.success(recipes))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(_ recipe: Recipe, _ newRecipe: RecipeModel) {
        
        recipe.category = newRecipe.category
        recipe.name = newRecipe.name
        recipe.source = newRecipe.source
        recipe.notes = newRecipe.notes
        recipe.ingredients = newRecipe.ingredients
        recipe.directions = newRecipe.directions
        recipe.setValue(newRecipe.photo, forKey: "photo")
        
        saveContext()
    }
    
    func addPhoto(in recipe: Recipe) {
        
        saveContext()
    }
}

// MARK: - Core Data Saving support

extension StorageManager {
    
    func saveContext() {
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
