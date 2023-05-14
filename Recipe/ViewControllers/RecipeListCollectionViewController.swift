//
//  RecipeListCollectionViewController.swift
//  Recipe
//
//  Created by Eugene on 11.04.23.
//

import UIKit

private let reuseIdentifier = "Cell"

final class RecipeListCollectionViewController: UICollectionViewController {
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private var recipes: [Recipe] = []
    
    var category: Category?
    var selectedRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        recipes = DataManager.shared.fetchRecipes(in: category)
        
        collectionView.reloadData()
    }
}

// MARK: - Navigation

extension RecipeListCollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let addRecipeVC = segue.destination as? AddRecipeViewController {
            addRecipeVC.category = category
//        } else if let recipeVC = segue.destination as? RecipeViewController {
//            recipeVC.recipe = selectedRecipe
        }
    }
}

// MARK: Collection View Data Source

extension RecipeListCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCell else { fatalError("Error cast recipe cell") }
        
        cell.layer.cornerRadius = Setting.cornerRadius
        cell.backgroundColor = .systemCyan
        
        let recipe = recipes[indexPath.row]
        
        cell.recipeCaption.text = recipe.name
        cell.recipeImage.image = fetchPhoto(from: recipe)

        return cell
    }
}

// MARK: - Collection View Delegate

extension RecipeListCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        selectedRecipe = recipes[indexPath.row]
        
        let recipeVC = RecipeViewController()
        
        recipeVC.recipe = selectedRecipe
        
        navigationController?.pushViewController(recipeVC, animated: true)
        
        return true
    }
}

// MARK: - Collection View Delegate Flow Layout

extension RecipeListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}

// MARK: - Common

private extension RecipeListCollectionViewController {
    
    func fetchPhoto(from recipe: Recipe) -> UIImage? {
        
        if let photoData = DataManager.shared.fetchPhotoData(from: recipe) {
            return UIImage(data: photoData)
        } else {
            return UIImage(systemName: "fork.knife")
        }
    }
}
