//
//  ViewController.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 29/06/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

struct SearchResult: Decodable {
    let count: Int
    let recipes: [Recipe]
}

struct RecipeResult: Decodable {
    let recipe: Recipe
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let query = QueryBuilder()
            .search(withParameters: "chicken")
            .page(withIndex: 2)
            .build()

        Service.execute(query, withUrl: Service.endpoints.search) { (result: SearchResult) in
            
            let q = QueryBuilder()
                .id(result.recipes[0].ID)
                .build()
            
            Service.execute(q, withUrl: Service.endpoints.get, complition: { (result: RecipeResult) in
                print(result.recipe.title)
            })   
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

