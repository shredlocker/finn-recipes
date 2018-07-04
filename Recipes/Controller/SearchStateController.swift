//
//  ViewController.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 29/06/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class SearchStateController: UIViewController {
    
    private var state: ViewState = .idle
    
    private let searchLogicController: SearchLogicController
    private var currentViewController: UIViewController?
    
    init() {
        self.searchLogicController = SearchLogicController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.headerText]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .headerText
        navigationController?.navigationBar.barTintColor = .background
        navigationItem.titleView = searchLogicController.searchBar
        searchLogicController.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        displayViewController(for: .idle)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("Tap tap tap tap tap")
        
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
    
    private func displayViewController(for state: ViewState) {
        
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

extension SearchStateController: SearchLogicDelegate {
    
    func searchLogicControllerDidBeginSearch(_ searchLogicController: SearchLogicController) {
        print("Did begin search")
    }
    
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveResult result: SearchResult) {
        print("Did recieve result")
        displayViewController(for: .result(result))
    }
    
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveError error: Error) {
        print(error)
        displayViewController(for: .error)
    }
    
    func searchLogicControllerDidRecieveEmptyResult(_ searchLogicController: SearchLogicController) {
        print("Empty result")
        displayViewController(for: .empty)
    }
    
}



extension SearchStateController {
    
    enum ViewState {
        case result(SearchResult)
        case idle, empty, error
    }
}
