//
//  ViewController.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 29/06/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit
import Alamofire

struct SearchResuls: Decodable {
    let count: Int
    let recipes: [Recipe]
}

struct Recipe: Decodable {
    let image_url: URL
    let title: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let query = QueryBuilder()
            .search(withParameters: "chicken")
            .page(withIndex: 2)
            .build()
        
        Service.execute(query, withUrl: Service.endpoints.search) { (result: SearchResuls) in
            print("Search result:\n")
            for recipe in result.recipes {
                print(recipe.title)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

