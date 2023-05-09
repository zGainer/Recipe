import UIKit

private let reuseIdentifier = "shoppingCell"

final class ShoppingViewController: UIViewController {
    
    @IBOutlet var shoppingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shoppingTable.delegate = self
        shoppingTable.dataSource = self
    }
}

// MARK: - Table View Data Source

extension ShoppingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "123"
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Table View Delegate

extension ShoppingViewController: UITableViewDelegate {
    
    
}
