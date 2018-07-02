//
//  Recipe.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 29/06/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import Foundation

class Recipe: Decodable {
    let image_url: URL
    let title: String
    let f2f_url: URL
    let ingredients: [String]?
    
    var ID: String {
        return f2f_url.lastPathComponent
    }
}

class SearchResult: Decodable {
    let count: Int
    let recipes: [Recipe]
}

class RecipeResult: Decodable {
    let recipe: Recipe
}
