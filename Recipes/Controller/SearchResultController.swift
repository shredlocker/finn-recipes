
import UIKit

class SearchResultController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .background
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var result = SearchResult.empty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        setupSubviews()
    }
    
    func setResult(_ result: SearchResult) {
        self.result = result
        tableView.reloadData()
    }
    
    func updateContent(at row: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SearchResultCell else { return }
        let recipe = result.recipes[row]
        cell.recipeImageView.image = recipe.image
        cell.titleLabel.text = recipe.title
        cell.gradientView.isHidden = false
    }
    
    func recipeForCell(at location: CGPoint) -> Recipe? {
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) as? SearchResultCell else { return nil }
        return cell.recipe
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension SearchResultController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        cell.reset()
        cell.recipe = result.recipes[indexPath.row]
        guard let image = cell.recipe?.image else { return cell }
        cell.recipeImageView.image = image
        cell.titleLabel.text = result.recipes[indexPath.row].title
        cell.gradientView.isHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
}

extension SearchResultController: UITableViewDelegate {
    
    
}





























