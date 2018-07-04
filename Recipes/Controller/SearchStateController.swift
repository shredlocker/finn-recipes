//
//  ViewController.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 29/06/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit
import Alamofire

class SearchStateController: UIViewController {
    
    private var state: SearchState = .idle
    
    private var searchDataRequest: Alamofire.DataRequest?
    
    private var currentViewController: UIViewController?
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.keyboardAppearance = .dark
        bar.barStyle = .blackOpaque
        bar.tintColor = .headerText
        bar.placeholder = "Search"
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        searchBar.delegate = self
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.headerText]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .headerText
        navigationController?.navigationBar.barTintColor = .background
        navigationItem.titleView = searchBar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        displayViewController(for: .idle)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("Tap tap tap tap tap")
        dismiss(searchBar)
        
        switch state {
            
        case .result:
            if let controller = currentViewController as? SearchResultViewController {
                let location = sender.location(in: controller.tableView)
                guard let recipe = controller.recipeForCell(at: location) else { return }
                let recipeController = RecipeViewController(recipe: recipe)
                navigationController?.pushViewController(recipeController, animated: true)
                
                let query = QueryBuilder()
                    .id(recipe.ID)
                    .build()
                
                Service.execute(query, withUrl: Service.endpoints.get) { (result: RecipeResult?, error) in
                    print("yaaaaaap")
                    guard let result = result else { return }
                    print("yoiiiiiiiå")
                    if let ingredients = result.recipe.ingredients {
                        print("jiiiippppe")
                        recipeController.update(ingredients: ingredients)
                    }
                }
            }
            break
            
        default:
            break
        }
    }
    
    private func displayViewController(for state: SearchState) {
        
        if let child = currentViewController {
            child.remove()
        }
        
        // Update class property
        self.state = state
        
        switch state {
        case .idle:
            print("Idle state")
            let idleController = SearchIdleController()
            setViewController(idleController)
            break
        case .empty:
            print("Empty state")
            let emptyController = SearchEmptyController()
            setViewController(emptyController)
            break
        case .result(let result):
            print("Result state")
            let restultController = SearchResultViewController(searchResult: result)
            setViewController(restultController)
            break
        case .error:
            print("Error state")
            let errorController = SearchErrorController()
            setViewController(errorController)
            break
        }
    }
    
    private func setViewController(_ viewController: UIViewController) {
        currentViewController = viewController
        add(viewController)
    }
}

extension SearchStateController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("Should begin editing")
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
        dismiss(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searc button clicked!")
        dismiss(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let request = searchDataRequest {
            request.cancel()
        }
        
        if searchText.isEmpty {
            print("Empty text")
            displayViewController(for: .idle)
            return
        }
        
        let query = QueryBuilder()
            .search(withParameters: searchText)
            .build()
        
        let request = Service.execute(query, withUrl: Service.endpoints.search) { (result: SearchResult?, error) in
            
            if let error = error {
                print(error)
                self.displayViewController(for: .error)
                return
            }
            
            guard let result = result else { return }
            
            guard result.count > 0 else {
                self.displayViewController(for: .empty)
                return
            }
            
            for (index, recipe) in result.recipes.enumerated() {
                Service.request(recipe.image_url, complition: { (image) in
                    guard let image = image else { return }
                    recipe.image = image
                    
                    if let controller = self.currentViewController as? SearchResultViewController {
                        controller.updateContent(at: index)
                    }
                })
            }
            
            DispatchQueue.main.async {
                self.displayViewController(for: .result(result))
            }
        }
        
        searchDataRequest = request
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Did end editing")
    }
    
    private func dismiss(_ searchBar: UISearchBar) {
        if searchBar.canResignFirstResponder {
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
        }
    }
}

extension SearchStateController {
    
    enum SearchState {
        case result(SearchResult)
        case idle, empty, error
    }
}
