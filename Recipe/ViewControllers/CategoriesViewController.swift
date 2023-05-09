import UIKit

private let reuseIdentifier = "categoryCell"

final class CategoriesViewController: UIViewController {
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private var categories: [Category] = []
    
    private var selectedCategory: Category?
    
    @IBOutlet var categoriesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        categoriesCollection.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        categories = DataManager.shared.fetchCategories()

        categoriesCollection.reloadData()
    }
}

// MARK: - Navigation

extension CategoriesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let recipeListVC = segue.destination as? RecipeListCollectionViewController else { return }
        
        recipeListVC.category = selectedCategory
    }
}

// MARK: Collection View Data Source
 
extension CategoriesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCell else { fatalError("Error cast category cell") }
        
        cell.layer.cornerRadius = Setting.cornerRadius
        cell.backgroundColor = .systemMint
        
        let category = categories[indexPath.row]
        
        let (photos, recipesCount) = fetchPhotos(in: category)
        
        if !photos.isEmpty {
            cell.categoryImage.image = photos[Int.random(in: 0...photos.count - 1)]
        } else {
            cell.categoryImage.image = UIImage(systemName: "cup.and.saucer")
        }
        
        cell.categoryCaption.backgroundColor = .systemCyan
        cell.numberOfReceipts.backgroundColor = .systemCyan
        
        cell.categoryCaption.text = category.name
        cell.numberOfReceipts.text = recipesCount.formatted()
                
        return cell
    }
}

// MARK: Collection View Delegate

extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        selectedCategory = categories[indexPath.row]
        
        return true
    }
}

// MARK: - Collection View Delegate Flow Layout

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
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
