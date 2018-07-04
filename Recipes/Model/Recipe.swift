//
//  Recipe.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 29/06/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

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
}

class RecipeResult: Decodable {
    let recipe: Recipe
}
