//
//  CategoriesViewController.swift
//  Recipe
//
//  Created by Eugene on 19.05.23.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private let editButton = UIBarButtonItem()
    
    private let reuseIdentifier = "CategoryCell"
    
    private var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func editButtonTapped() {
        
        let categoriesListVC = CategoriesListViewController()
        
        categoriesListVC.completion = { [unowned self] in
            fetchCategories()
            
            collectionView.reloadData()
        }
        
        navigationController?.pushViewController(categoriesListVC, animated: true)
    }
}

// MARK: Collection View Data Source

extension CategoriesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCell else { fatalError("Error cast category cell.") }
        
        let category = categories[indexPath.row]
        
        let (photos, recipesCount) = fetchPhotos(in: category)
        
        if !photos.isEmpty {
            cell.recipePhoto.image = photos[Int.random(in: 0...photos.count - 1)]
        } else {
            cell.recipePhoto.image = UIImage(systemName: "cup.and.saucer")
        }
        
        cell.caption.text = category.name
        cell.numberOfRecipes.text = recipesCount.formatted()
        
        return cell
    }
}

// MARK: - Collection View Delegate

extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCategory = categories[indexPath.row]
        
        let recipeListVC = RecipeListViewController()
        
        recipeListVC.category = selectedCategory
        
        navigationController?.pushViewController(recipeListVC, animated: true)
    }
}

// MARK: - Collection View Delegate Flow Layout

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
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
    
    func fetchCategories() {
        categories = DataManager.shared.fetchCategories()
    }
}

// MARK: - Setup View

private extension CategoriesViewController {
    
    func setupUI() {
        
        createViews()
        
        addViews()
        
        addActions()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension CategoriesViewController {
    
    func addViews() {
        
        view.addSubview(collectionView)
    }
    
    func addActions() {
        
        editButton.target = self
        editButton.action = #selector(editButtonTapped)
    }
    
    func configure() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tabBarController?.tabBar.items?.first?.image = UIImage(systemName: "house.fill")
        tabBarController?.tabBar.items?.first?.title = "Home"
        
        tabBarController?.tabBar.items?.last?.image = UIImage(systemName: "cart.fill")
        tabBarController?.tabBar.items?.last?.title = "Shopping"
        
        fetchCategories()
        
        editButton.title = "Edit"
        
        navigationItem.title = "Categories"
    }
    
    func createViews() {
        
        let layout = Setting.fetchCollectionLayout()
                
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - Layout

private extension CategoriesViewController {
    
    func layout() {
        
        navigationItem.leftBarButtonItems = [editButton]
    }
}
