
import UIKit

class RecipeViewController: UIViewController {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ingredientsView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = recipe.title
        
        imageView.image = recipe.image
        ingredientsView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ingredientsView.dataSource = self
        ingredientsView.delegate = self
        
        setupSubviews()
    }
    
    func update(ingredients: [String]) {
        recipe.ingredients = ingredients
        
        let indexPaths = (0..<ingredients.count).map { (row) -> IndexPath in
            return IndexPath(row: row, section: 0)
        }
        
        ingredientsView.insertRows(at: indexPaths, with: .fade)
    }
    
    private func setupSubviews() {
        [imageView, ingredientsView].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            ingredientsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            ingredientsView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            ingredientsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ingredientsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .background
        cell.textLabel?.text = nil
        guard let ingredients = recipe.ingredients else { return cell }
        cell.textLabel?.textColor = .textColor
        cell.textLabel?.text = ingredients[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = recipe.ingredients?.count else { return 0 }
        return count
    }
}
