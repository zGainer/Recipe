//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Eugene on 10.05.23.
//

import UIKit

final class RecipeViewController: UIViewController, UINavigationControllerDelegate {
    
    private let scrollView = UIScrollView()

    private let mainStackView = UIStackView()
    private let overviewStackView = UIStackView()
    private let detailsStackView = UIStackView()
    
    private let addPhotoButton = UIBarButtonItem()
    private let editButton = UIBarButtonItem()
    private let deleteButton = UIBarButtonItem()
    
    private let name = UILabel()
    private let source = UILabel()
    private let notes = UILabel()
    private let ingredients = UILabel()
    private let directions = UILabel()
    
    private let photoImageView = UIImageView()
    
    private let imagePicker = UIImagePickerController()
    
    var recipe: Recipe?
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        completion?()
    }
    
    // MARK: - Actions
    
    @objc
    private func addPhotoButtonTapped() {
        
        present(imagePicker, animated: true)
    }
    
    @objc
    private func editButtonTapped() {

        let addRecipeVC = AddRecipeViewController()
        
        addRecipeVC.recipe = recipe
        
        addRecipeVC.completion = { [unowned self] in
            fillRecipeData()
        }
        
        navigationController?.pushViewController(addRecipeVC, animated: true)
    }
    
    @objc
    private func deleteButtonTapped() {
        
        guard let recipe else { return }
        
        showAlert { [unowned self] in
            DataManager.shared.delete(recipe)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Image Picker Controller Delegate

extension RecipeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            photoImageView.image = pickedImage
            
            addPhoto(pickedImage)
            
            photoImageView.isHidden = recipe?.photo == nil
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true)
    }
}

// MARK: - Common

private extension RecipeViewController {
    
    func fillRecipeData() {
        
        guard let recipe else { return }
        
        name.text = recipe.name
        source.text = recipe.source
        notes.text = recipe.notes
        ingredients.text = recipe.ingredients
        directions.text = recipe.directions
        
        if let photoData = DataManager.shared.fetchPhotoData(from: recipe) {
            photoImageView.image = UIImage(data: photoData)
        } else {
            let configuration = UIImage.SymbolConfiguration(weight: .ultraLight)
            
            photoImageView.image = UIImage(systemName: "popcorn", withConfiguration: configuration)
        }
    }
    
    func addPhoto(_ pickedImage: UIImage) {
        
        guard let recipe else { return }
        
        recipe.setValue(pickedImage.pngData(), forKey: "photo")
        
        DataManager.shared.addPhoto(in: recipe)
    }
    
    func getCaption(withText: String) -> UILabel {
        
        let label = UILabel()
        
        label.text = withText
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        
        return label
    }
    
    func showAlert(completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController.createAlert(withTitle: "Delete recipe?")
        
        let ok = UIAlertAction(title: "Ok", style: .destructive) { _ in
            guard let completion else { return }
            
            completion()
        }
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

// MARK: - Setup View

private extension RecipeViewController {
    
    func setupUI() {
        
        addViews()
        
        addActions()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension RecipeViewController {
    
    func addViews() {

        view.addSubview(scrollView)
        
        scrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(photoImageView)
        mainStackView.addArrangedSubview(name)
        mainStackView.addArrangedSubview(overviewStackView)
        mainStackView.addArrangedSubview(detailsStackView)
        mainStackView.addArrangedSubview(getCaption(withText: "Ingredients:"))
        mainStackView.addArrangedSubview(ingredients)
        mainStackView.addArrangedSubview(getCaption(withText: "Directions:"))
        mainStackView.addArrangedSubview(directions)
        
        overviewStackView.addArrangedSubview(getCaption(withText: "Source: "))
        overviewStackView.addArrangedSubview(source)
        
        detailsStackView.addArrangedSubview(getCaption(withText: "Notes: "))
        detailsStackView.addArrangedSubview(notes)
    }
    
    func addActions() {
        
        addPhotoButton.target = self
        addPhotoButton.action = #selector(addPhotoButtonTapped)
        
        editButton.target = self
        editButton.action = #selector(editButtonTapped)
        
        deleteButton.target = self
        deleteButton.action = #selector(deleteButtonTapped)
    }
    
    func configure() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        fillRecipeData()
        
        addPhotoButton.image = UIImage(systemName: "photo")
        editButton.title = "Edit"
        deleteButton.image = UIImage(systemName: "trash")
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        
        overviewStackView.axis = .horizontal
        
        scrollView.backgroundColor = .systemMint
        
        ingredients.numberOfLines = 0
        ingredients.lineBreakMode = .byWordWrapping
        
        directions.numberOfLines = 0
        directions.lineBreakMode = .byWordWrapping
    }
}

// MARK: - Layout

private extension RecipeViewController {
    
    func layout() {
        
        [scrollView, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
                                     
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),

            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1),
        ])
        
        navigationItem.rightBarButtonItems = [addPhotoButton, editButton, deleteButton]
    }
}
