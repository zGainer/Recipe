//
//  CategoriesListViewController.swift
//  Recipe
//
//  Created by Eugene on 18.05.23.
//

import UIKit

final class CategoriesListViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private let addRecipeButton = UIBarButtonItem()
    private let editButton = UIBarButtonItem()
    
    private var categories = DataManager.shared.fetchCategories()
    
    private let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    func editButtonTapped() {
        
        tableView.isEditing.toggle()
    }
    
    @objc
    func addButtonTapped() {
        
        showAddAlert(withTitle: "Add new category") { [unowned self] in
            let indexPath = IndexPath(row: categories.count - 1, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Delete Action

extension CategoriesListViewController {
    
    func deleteItems(with indexPath: IndexPath) {
        
        let category = categories[indexPath.row]
        let recipes = DataManager.shared.fetchRecipes(in: category)
        
        if recipes.count > 0 {
            let alert = UIAlertController.createAlert(withTitle: "Delete all recipes in this category?",
                                                      andMessage: "Category have \(recipes.count) recipes.")
            
            let ok = UIAlertAction(title: "Ok", style: .destructive) { [unowned self] _ in
                delete(recipes)
                delete(category, with: indexPath)
            }
            
            alert.addAction(ok)

            present(alert, animated: true)
        } else {
            delete(category, with: indexPath)
        }
    }
    
    func delete(_ recipes: [Recipe]) {

        for recipe in recipes {
            DataManager.shared.delete(recipe)
        }
    }
    
    func delete(_ category: Category, with indexPath: IndexPath) {
        
        categories.remove(at: indexPath.row)
        
        DataManager.shared.delete(category)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Table View Data Source

extension CategoriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let category = categories[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = category.name
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Table View Delegate

extension CategoriesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, isDone in
            
            deleteItems(with: indexPath)
            
            isDone(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {  [unowned self] _, _, isDone in
            
            showEditAlert(for: indexPath.row, withTitle: "Edit category") {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Alert Controller

extension CategoriesListViewController {
    
    func showAddAlert(withTitle title: String, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController.createAlert(withTitle: title)
        
        let save = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let name = alert.textFields?.first?.text,
                    !name.isEmpty,
                    let completion else { return }
            
            StorageManager.shared.create(name) { [unowned self] category in
                self.categories.append(category)
                
                completion()
            }
        }
        
        alert.addAction(save)
        
        alert.addTextField { textField in
            
            textField.placeholder = "Category name"
        }
        
        present(alert, animated: true)
    }
    
    func showEditAlert(for categoryIndex: Int, withTitle title: String, completion: (() -> Void)? = nil) {
        
        let category = categories[categoryIndex]
        
        let alert = UIAlertController.createAlert(withTitle: title)

        let save = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let newName = alert.textFields?.first?.text,
                    !newName.isEmpty,
                    newName != category.name,
                    let completion else { return }
            
            StorageManager.shared.update(category, newName: newName)
            
            categories[categoryIndex].name = newName
            
            completion()
        }
        
        alert.addAction(save)
        
        alert.addTextField() { textField in
            textField.text = category.name
        }
        
        present(alert, animated: true)
    }
}

// MARK: - Setup View

private extension CategoriesListViewController {
    
    func setupUI() {
        
        createViews()
        
        addViews()
        
        addActions()
        
        configure()
        
        layout()
    }
}

// MARK: - Setup Subviews

private extension CategoriesListViewController {
    
    func addViews() {
        
        view.addSubview(tableView)
    }
    
    func addActions() {
        
        editButton.target = self
        editButton.action = #selector(editButtonTapped)
        
        addRecipeButton.target = self
        addRecipeButton.action = #selector(addButtonTapped)
    }
    
    func configure() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        editButton.title = "Edit"
        addRecipeButton.image = UIImage(systemName: "plus")
    }
    
    func createViews() {
        
        tableView = UITableView(frame: view.bounds)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - Layout

private extension CategoriesListViewController {
    
    func layout() {
        
        navigationItem.rightBarButtonItems = [addRecipeButton, editButton]
    }
}
