//
//  DataManager.swift
//  Recipe
//
//  Created by Eugene on 29.04.23.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func fetchCategories() -> [Category] {
        
        var fetchedCategories: [Category] = []
        
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let categories):
                fetchedCategories = categories
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return fetchedCategories
    }
    
    func fetchRecipes(in category: Category?) -> [Recipe] {
        
        var fetchedRecipes: [Recipe] = []
        
        guard let categoryName = category?.name else { fatalError("Can`t unwrap category") }
        
        StorageManager.shared.fetchData(with: categoryName) { result in
            switch result {
            case .success(let recipes):
                fetchedRecipes = recipes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return fetchedRecipes
    }
    
    func saveRecipe(_ recipe: Recipe?, newRecipe: RecipeModel) {
        
        if let recipe {
            StorageManager.shared.update(recipe, newRecipe)
        } else {
            StorageManager.shared.create(newRecipe) { _ in
            }
        }
    }
    
    func addPhoto(in recipe: Recipe) {
        
        StorageManager.shared.addPhoto(in: recipe)
    }
    
    func fetchPhotoData(from recipe: Recipe?) -> Data? {
        
        guard let photoData = recipe?.value(forKey: "photo") as? Data else { return nil }
        
        return photoData
    }
    
    func delete(_ recipe: Recipe) {
        
        StorageManager.shared.delete(recipe)
    }
    
    func delete(_ category: Category) {
        
        StorageManager.shared.delete(category)
    }
}
