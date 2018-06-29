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
    let image_url: URL?
    let title: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let searchApi = URL(string: "https://food2fork.com/api/search") else { return }
        
        let parameters: Parameters = [
            "key": "20df2dd77ca96c91466c41b355a10f48",
            "q": "chicken"
        ]
        
        let request = Alamofire.request(searchApi, method: .post, parameters: parameters, encoding: URLEncoding.default)
        request.responseData { (response) in
            
            guard let data = response.value else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResult = try decoder.decode(SearchResuls.self, from: data)
                
                for recipe in searchResult.recipes {
                    print(recipe.title)
                }
                
            } catch let jsonError {
                print("Error decoding JSON,", jsonError)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

