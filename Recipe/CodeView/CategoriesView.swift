//
//  CategoriesView.swift
//  Recipe
//
//  Created by Eugene on 19.05.23.
//

import UIKit

final class CategoriesView: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private let reuseIdentifier = "CategoryCellCL"
    
    private var categories: [Category] = []
    
//    private var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
}

// MARK: Collection View Data Source

extension CategoriesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCellCL else { fatalError( "Error cast category cell." ) }
        
        cell.caption.text = "sdfsfd"
        cell.numberOfRecipes.text = "5"
        
        return cell
    }
}

// MARK: - Collection View Delegate

extension CategoriesView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCategory = categories[indexPath.row]
        
        let recipeListVC = RecipeListViewController()
        
        recipeListVC.category = selectedCategory
        
        navigationController?.pushViewController(recipeListVC, animated: true)
    }
}

// MARK: - Collection View Delegate Flow Layout

extension CategoriesView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let sizeForItem = Setting.fetchSizeOfCollectionItem(for: collectionView.frame.width)
        
        return sizeForItem
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Setting.sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Setting.sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Setting.sectionInserts.left
    }
}

// MARK: - Common

private extension CategoriesViewController {
    
    func fetchPhotos(in category: Category) -> (photos: [UIImage], recipesCount: Int) {
        
        var photos: [UIImage] = []
        
        let recipes = DataManager.shared.fetchRecipes(in: category)
        
        for recipe in recipes {
            if let photoData = DataManager.shared.fetchPhotoData(from: recipe) {
                if let photo = UIImage(data: photoData) {
                    photos.append(photo)
                }
            }
        }
        
        return (photos, recipes.count)
    }
}

// MARK: - Setup View

private extension CategoriesView {
    
    func setupUI() {
        
        createViews()
        
        addViews()
        
        addActions()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension CategoriesView {
    
    func addViews() {
        
        view.addSubview(collectionView)
    }
    
    func addActions() {
        
//        addRecipeButton.target = self
//        addRecipeButton.action = #selector(addButtonTapped)
    }
    
    func configure() {
        
        
//        addRecipeButton.image = UIImage(systemName: "plus")
        
        navigationItem.title = "Categories"
    }
    
    func createViews() {
        
        let layout = Setting.fetchCollectionLayout()
                
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Layout

private extension CategoriesView {
    
    func layout() {
        
//        navigationItem.rightBarButtonItems = [addRecipeButton]
    }
}
