//
//  AddRecipeViewController.swift
//  Recipe
//
//  Created by Eugene on 26.05.23.
//

import UIKit

final class AddRecipeViewController: UIPageViewController {
    
    private let overviewVC = UIViewController()
    private let ingredientsVC = UIViewController()
    private let directionsVC = UIViewController()
    
    private let saveButton = UIBarButtonItem()
    
    private let segmentedControl = UISegmentedControl()

    private let mainStackView = UIStackView()
    private let nameStackView = UIStackView()
    private let sourceStackView = UIStackView()
    private let notesStackView = UIStackView()
    
    private let photoImageView = UIImageView()
    
    private let categories = DataManager.shared.fetchCategories()
    
    private let categoryPickerView = UIPickerView()
    
    private let categoryButton = UIButton()
    
    private let name = UITextField()
    private let source = UITextField()
    private let notes = UITextField()
    
    private let ingredients = UITextView()
    private let directions = UITextView()
    
    private var oldTabbarFrame: CGRect = .zero
    
    private var views: [UIViewController] = []
    
    var category: Category?
    var recipe: Recipe?
    
    var completion: (() -> Void)?
    
    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldTabbarFrame = self.tabBarController?.tabBar.frame ?? .zero
        
        view.backgroundColor = .systemRed
        
        overviewVC.view.backgroundColor = .brown
        ingredientsVC.view.backgroundColor = .black
        directionsVC.view.backgroundColor = .blue
        
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
    
    // MARK: - Actions
    
    @objc
    private func saveButtonTapped() {
        
        guard let newRecipe = fetchRecipe() else { return }
        
        DataManager.shared.saveRecipe(recipe, newRecipe: newRecipe)
        
        completion?()
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Page View Controller Data Source

extension AddRecipeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = views.firstIndex(of: viewController), index > 0 else { return nil }

        let before = index - 1
        
        return views[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = views.firstIndex(of: viewController), index < views.count - 1 else { return nil }

        let after = index + 1
        
        return views[after]
    }
}

// MARK: - Page View Controller Delegate

extension AddRecipeViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentPageIndex = getCurrentPageIndex() else { return }
        
        segmentedControl.selectedSegmentIndex = currentPageIndex
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

// MARK: - Text Field Delegate

extension AddRecipeViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {

        categoryPickerView.isHidden = true
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
            let alert = UIAlertController.createAlert(withTitle: "Select category", buttonTitle: "Ok")
            present(alert, animated: true)
            
            return nil
        }
        
        let name = name.text ?? ""
        
        return RecipeModel(name: name.isEmpty ? "New recipe" : name,
                           category: category,
                           source: source.text ?? "",
                           notes: notes.text ?? "",
                           ingredients: ingredients.text,
                           directions: directions.text,
                           photo: DataManager.shared.fetchPhotoData(from: recipe))
    }
    
    func fillFields(from recipe: Recipe) {

        category = recipe.category
        
        name.text = recipe.name
        source.text = recipe.source
        notes.text = recipe.notes
        ingredients.text = recipe.ingredients
        directions.text = recipe.directions
    }
    
    func getCurrentPageIndex() -> Int? {
        
        guard let currentViewController = self.viewControllers?.first else { return nil }
        guard let currentPageIndex = views.firstIndex(of: currentViewController) else { return nil }
        
        return currentPageIndex
    }
    
    func getCaption(withText: String) -> UILabel {
        
        let label = UILabel()
        
        label.text = withText
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        
        return label
    }
}

// MARK: - Setup View

private extension AddRecipeViewController {
    
    func setupUI() {
        
        addViews()
        
        addActions()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension AddRecipeViewController {
    
    // MARK: Add Views
    
    func addViews() {
        
        view.addSubview(segmentedControl)
        
        overviewVC.view.addSubview(mainStackView)
        
//        mainStackView.addArrangedSubview(photoImageView)
        mainStackView.addArrangedSubview(categoryButton)
        mainStackView.addArrangedSubview(categoryPickerView)
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(sourceStackView)
        mainStackView.addArrangedSubview(notesStackView)

        nameStackView.addArrangedSubview(name)
        nameStackView.addArrangedSubview(getCaption(withText: "Name: "))
        
        sourceStackView.addArrangedSubview(source)
        sourceStackView.addArrangedSubview(getCaption(withText: "Source: "))
        
        notesStackView.addArrangedSubview(notes)
        notesStackView.addArrangedSubview(getCaption(withText: "Notes: "))
        
        ingredients.backgroundColor = .cyan
        
        ingredientsVC.view.addSubview(ingredients)
        
        directions.backgroundColor = .green
        directionsVC.view.addSubview(directions)
    }
    
    // MARK: Add Actions
    
    func addActions() {
        
        let selectedViewAction = UIAction(handler: { [unowned self] _ in
            let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
            
            guard selectedSegmentIndex < views.count else { return }
            
            guard let currentPageIndex = getCurrentPageIndex() else { return }
            
            let selectedView = views[selectedSegmentIndex]
            
            let direction: UIPageViewController.NavigationDirection
            
            direction = selectedSegmentIndex < currentPageIndex ? .reverse : .forward
            
            self.setViewControllers([selectedView], direction: direction, animated: true)
        })
        
        segmentedControl.addAction(selectedViewAction, for: .valueChanged)
        
        let categoryButtonAction = UIAction(handler: { [unowned self] _ in
            if let category {
                let index = categories.firstIndex(of: category)
                
                categoryPickerView.selectRow(index ?? 0, inComponent: 0, animated: false)
            }
            
            view.endEditing(true)
            
            categoryPickerView.isHidden.toggle()
        })
        
        categoryButton.addAction(categoryButtonAction, for: .touchDown)
        
        saveButton.target = self
        saveButton.action = #selector(saveButtonTapped)
    }
    
    // MARK: Configure
    
    func configure() {
        
        dataSource = self
        delegate = self
        
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        name.delegate = self
        source.delegate = self
        notes.delegate = self
        
        setupGestures()
        
        if let recipe {
            fillFields(from: recipe)
            
            navigationItem.title = "edit recipe"
        } else {
            navigationItem.title = "add recipe"
        }
        
        views = [overviewVC, ingredientsVC, directionsVC]

        if let first = views.first {
            self.setViewControllers([first], direction: .forward, animated: true)
        }
        
        segmentedControl.insertSegment(withTitle: "Overview", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Ingredients", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Directions", at: 2, animated: true)
        
        segmentedControl.selectedSegmentIndex = 0

        photoImageView.image = UIImage(systemName: "fork.knife")
        
        categoryButton.setTitle(category?.name ?? "Select category", for: .normal)
        
        categoryPickerView.isHidden = true
        
        name.placeholder = "Enter name"
        source.placeholder = "Enter source"
        notes.placeholder = "Enter note"
        
        ingredients.font = UIFont.systemFont(ofSize: name.font?.pointSize ?? UIFont.systemFontSize)
        directions.font = UIFont.systemFont(ofSize: name.font?.pointSize ?? UIFont.systemFontSize)
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        
        nameStackView.semanticContentAttribute = .forceRightToLeft
        sourceStackView.semanticContentAttribute = .forceRightToLeft
        notesStackView.semanticContentAttribute = .forceRightToLeft

        saveButton.title = "Save"
    }
}

// MARK: - Layout

private extension AddRecipeViewController {
    
    func layout() {
        
        [segmentedControl, mainStackView,  ingredients, directions].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: overviewVC.view.topAnchor, constant: 140),
            mainStackView.leadingAnchor.constraint(equalTo: overviewVC.view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: overviewVC.view.trailingAnchor, constant: -16),
            
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1),
            
            ingredients.topAnchor.constraint(equalTo: ingredientsVC.view.topAnchor, constant: 140),
            ingredients.leadingAnchor.constraint(equalTo: ingredientsVC.view.leadingAnchor),
            ingredients.trailingAnchor.constraint(equalTo: ingredientsVC.view.trailingAnchor),
            ingredients.bottomAnchor.constraint(equalTo: ingredientsVC.view.bottomAnchor),
            
            directions.topAnchor.constraint(equalTo: directionsVC.view.topAnchor, constant: 140),
            directions.leadingAnchor.constraint(equalTo: directionsVC.view.leadingAnchor),
            directions.trailingAnchor.constraint(equalTo: directionsVC.view.trailingAnchor),
            directions.bottomAnchor.constraint(equalTo: directionsVC.view.bottomAnchor),
        ])
        
        navigationItem.rightBarButtonItems = [saveButton]
    }
}
