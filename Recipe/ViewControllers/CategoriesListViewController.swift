//
//  CategoriesListViewController.swift
//  Recipe
//
//  Created by Eugene on 9.04.23.
//

import UIKit

private let reuseIdentifier = "Cell"

final class CategoriesListViewController: UITableViewController {
    
    private var categories = DataManager.shared.fetchCategories()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        tableView.isEditing.toggle()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        showAlert(withTitle: "Add new category") { [unowned self] in
            let indexPath = IndexPath(row: categories.count - 1, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Table View Data Source

extension CategoriesListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = category.name
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Table View Delegate

extension CategoriesListViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, isDone in
            
            deleteItems(with: indexPath)
            
            isDone(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            
            showAlert(for: indexPath.row, withTitle: "Edit category") {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            isDone(true)
        }

        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Delete Action

private extension CategoriesListViewController {
    
    func deleteItems(with indexPath: IndexPath) {
        
        let category = categories[indexPath.row]
        let recipes = DataManager.shared.fetchRecipes(in: category)
        
        if recipes.count > 0 {
            let alert = createAlert(withTitle: "Delete all recipes in a category?",
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

// MARK: - Alert Controller

private extension CategoriesListViewController {
    
    func showAlert(for categoryIndex: Int, withTitle title: String, completion: (() -> Void)? = nil) {
        
        let category = categories[categoryIndex]
        
        let alert = createAlert(withTitle: title)

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
    
    func showAlert(withTitle title: String, completion: (() -> Void)? = nil) {
        
        let alert = createAlert(withTitle: title)
        
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
        
        alert.addTextField() { textField in
            textField.placeholder = "Category name"
        }
        
        present(alert, animated: true)
    }
    
    func createAlert(withTitle title: String, andMessage message: String = "", buttonTitle: String = "Cancel") -> UIAlertController {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: buttonTitle, style: .cancel)
        
        alert.addAction(cancel)
        
        return alert
    }
}
