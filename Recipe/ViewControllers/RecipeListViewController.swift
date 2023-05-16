//
//  RecipeListViewController.swift
//  Recipe
//
//  Created by Eugene on 16.05.23.
//

import UIKit

final class RecipeListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private let addRecipeButton = UIBarButtonItem()
    
    private let reuseIdentifier = "RecipeCell"
    
    private var recipes: [Recipe] = []
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        recipes = DataManager.shared.fetchRecipes(in: category)
        
        collectionView.reloadData()
    }
}

// MARK: Collection View Data Source

extension RecipeListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCell else { fatalError("Error cast recipe cell") }
        
        let recipe = recipes[indexPath.row]

        cell.recipeCaption.text = recipe.name
        cell.recipePhoto.image = fetchPhoto(from: recipe)

        return cell
    }
}

// MARK: - Collection View Delegate

extension RecipeListViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedRecipe = recipes[indexPath.row]
        
        let recipeVC = RecipeViewController()
        
        recipeVC.recipe = selectedRecipe
        
        navigationController?.pushViewController(recipeVC, animated: true)
    }
}

// MARK: - Collection View Delegate Flow Layout

extension RecipeListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = Setting.sectionInserts.left * (Setting.itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / Setting.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

// MARK: - Common

private extension RecipeListViewController {
    
    func fetchPhoto(from recipe: Recipe) -> UIImage? {
        
        if let photoData = DataManager.shared.fetchPhotoData(from: recipe) {
            return UIImage(data: photoData)
        } else {
            return UIImage(systemName: "fork.knife")
        }
    }
    
    func fetchLayout() -> UICollectionViewFlowLayout {

        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = Setting.sectionInserts
        layout.minimumLineSpacing = Setting.sectionInserts.left
        layout.minimumInteritemSpacing = Setting.sectionInserts.left

        return layout
    }
    
    @objc
    func addButtonTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addRecipeVC = storyboard.instantiateViewController(withIdentifier: "addRecipeVC") as! AddRecipeViewController
        
        addRecipeVC.category = category
        
        navigationController?.pushViewController(addRecipeVC, animated: true)
    }
}

// MARK: - Setup View

private extension RecipeListViewController {
    
    func setupUI() {
        
        createViews()
        
        addViews()
        
        addActions()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension RecipeListViewController {
    
    func addViews() {
        
        view.addSubview(collectionView)
    }
    
    func addActions() {
        
        addRecipeButton.target = self
        addRecipeButton.action = #selector(addButtonTapped)
    }
    
    func configure() {
        
        addRecipeButton.image = UIImage(systemName: "plus")
        
        navigationItem.title = category?.name
    }
    
    func createViews() {
        
        let layout = fetchLayout()
                
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Layout

private extension RecipeListViewController {
    
    func layout() {
        
        navigationItem.rightBarButtonItems = [addRecipeButton]
    }
}
