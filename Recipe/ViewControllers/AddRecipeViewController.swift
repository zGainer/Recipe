//
//  AddRecipeViewController.swift
//  Recipe
//
//  Created by Eugene on 7.04.23.
//

import UIKit

final class AddRecipeViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var sourceTextField: UITextField!
    @IBOutlet var notesTextField: UITextField!
    
    @IBOutlet var ingredientsTextView: TextView!
    @IBOutlet var directionsTextView: TextView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var categoryPickerView: UIPickerView!
    
    @IBOutlet var categoryButton: UIButton!
    
    private let categories = DataManager.shared.fetchCategories()
    
    private var oldTabbarFrame: CGRect = .zero
    
    var category: Category?
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldTabbarFrame = self.tabBarController?.tabBar.frame ?? .zero
        
        view.backgroundColor = .systemCyan
        
        setup()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = .zero
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.frame = oldTabbarFrame
    }
    
    // MARK: - IBAction
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        
        view.endEditing(true)
        
        categoryPickerView.isHidden = categories.isEmpty || !categoryPickerView.isHidden
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let newRecipe = fetchRecipe() else { return }
        
        DataManager.shared.saveRecipe(recipe, newRecipe: newRecipe)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Text Field Delegate

extension AddRecipeViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {

        categoryPickerView.isHidden = true
    }
}

// MARK: - Text View Delegate

extension AddRecipeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        categoryPickerView.isHidden = true
        
        setTextViewContentOffset(tag: textView.tag)
    }
    
    func textViewDidChange(_ textView: UITextView) {

        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
        
        setTextViewContentOffset(tag: textView.tag)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == 1 {
            let topOffset = CGPoint(x: 0, y: -scrollView.contentOffset.y)
            
            scrollView.setContentOffset(topOffset, animated: true)
        }
    }
}

// MARK: - Picker View Delegate

extension AddRecipeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        category = categories[row]
        
        categoryButton.setTitle(category?.name, for: .normal)
        
        categoryPickerView.isHidden = true
    }
}

// MARK: - Picker View Data Source

extension AddRecipeViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        categories.count
    }
}

// MARK: - Tap Gesture

private extension AddRecipeViewController {
    
    func setupGestures() {
        
        let tapScreen = UITapGestureRecognizer(target: self,
                                               action: #selector(dismissKeyboard))
        
        tapScreen.cancelsTouchesInView = false
        
        view.addGestureRecognizer (tapScreen)
    }
    
    @objc
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - Common

private extension AddRecipeViewController {
    
    func fetchRecipe() -> RecipeModel? {
        
        guard let category else {
            showAlert(withTitle: "Select category.")
            
            return nil
        }
        
        let name = nameTextField.text ?? ""
        
        return RecipeModel(name: name.isEmpty ? "New recipe" : name,
                           category: category,
                           source: sourceTextField.text ?? "",
                           notes: notesTextField.text ?? "",
                           ingredients: ingredientsTextView.text,
                           directions: directionsTextView.text,
                           photo: DataManager.shared.fetchPhotoData(from: recipe))
    }
    
    func fillFields(from recipe: Recipe) {
        
        category = recipe.category
        
        nameTextField.text = recipe.name
        sourceTextField.text = recipe.source
        notesTextField.text = recipe.notes
        ingredientsTextView.text = recipe.ingredients
        directionsTextView.text = recipe.directions
    }
    
    func setTextViewContentOffset(tag: Int) {
        
        guard let pointSize = directionsTextView.font?.pointSize else { return }
        
        // 1 - Directions, 0 - Ingredients
        if tag == 1 {
            let numberOfLines = directionsTextView.text.components(separatedBy: .newlines).count
            
            let heightOffset = Double(numberOfLines) * pointSize * 2.4
            
            scrollView.setContentOffset(CGPoint(x: 0, y: heightOffset), animated: true)
        }
    }
    
    func setup() {
        
        nameTextField.delegate = self
        sourceTextField.delegate = self
        notesTextField.delegate = self
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        ingredientsTextView.delegate = self
        directionsTextView.delegate = self
        
        setupGestures()
    }
    
    func setupUI() {
        
        if let recipe {
            fillFields(from: recipe)
            
            navigationItem.title = "edit recipe"
        }
        
        ingredientsTextView.placeholder = "Ingredients"
        directionsTextView.placeholder = "Directions"
                
        categoryButton.setTitle(category?.name, for: .normal)
        
        categoryPickerView.isHidden = true
    }
}

// MARK: - Alert Controller

extension AddRecipeViewController {
    
    func showAlert(withTitle title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
