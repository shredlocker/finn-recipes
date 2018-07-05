
import UIKit

class Recipe: Decodable {
    let image_url: URL
    let title: String
    let f2f_url: URL
    var ingredients: [String]?
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case image_url, title, f2f_url, ingredients
    }
    
    var ID: String {
        return f2f_url.lastPathComponent
    }
    
    init() {
        fatalError()
    }
}

class SearchResult: Decodable {
    let count: Int
    let recipes: [Recipe]
    
    init(count: Int, recipes: [Recipe]) {
        self.count = count
        self.recipes = recipes
    }
    
    static func empty() -> SearchResult {
        return SearchResult(count: 0, recipes: [])
    }
}

class RecipeResult: Decodable {
    let recipe: Recipe
}
