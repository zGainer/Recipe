//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Eugene on 13.04.23.
//

import UIKit

final class RecipeViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var source: UILabel!
    @IBOutlet var notes: UILabel!
    @IBOutlet var ingredients: UILabel!
    @IBOutlet var directions: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var recipeImageView: UIImageView!
    
    private let imagePicker = UIImagePickerController()
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fillRecipeData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let addRecipeVC = segue.destination as? AddRecipeViewController else { fatalError("Can`t cast edit recipe controller.") }
        
        addRecipeVC.recipe = recipe
    }
    
    // MARK: - IBAction
    
    @IBAction func addPhotoButtonTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        
        if let recipe {
            showAlert { [unowned self] in
                DataManager.shared.delete(recipe)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - Image Picker Controller Delegate

extension RecipeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            recipeImageView.image = pickedImage
            
            addPhoto(pickedImage)
            
            recipeImageView.isHidden = recipe?.photo == nil
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true)
    }
}

// MARK: - Common

private extension RecipeViewController {
    
    func addPhoto(_ pickedImage: UIImage) {
        
        if let recipe {
            recipe.setValue(pickedImage.pngData(), forKey: "photo")
            
            DataManager.shared.addPhoto(in: recipe)
        }
    }
    
    func fillRecipeData() {
        
        if let recipe {
            name.text = recipe.name
            source.text = recipe.source
            notes.text = recipe.notes
            ingredients.text = recipe.ingredients
            directions.text = recipe.directions
            
            if let photoData = DataManager.shared.fetchPhotoData(from: recipe) {
                recipeImageView.image = UIImage(data: photoData)
            }
        }
    }
    
    func showAlert(completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Delete recipe?", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .destructive) { _ in
            completion()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
