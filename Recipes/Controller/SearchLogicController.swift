//
//  SearchLogicViewController.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 04/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchLogicDelegate: class {
    func searchLogicControllerDidBeginSearch(_ searchLogicController: SearchLogicController)
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveResult result: SearchResult)
    func searchLogicControllerDidRecieveEmptyResult(_ searchLogicController: SearchLogicController)
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveError error: Error)
}

class SearchLogicController: UIViewController {

    // MARK: Subviews
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.keyboardAppearance = .dark
        bar.barStyle = .blackOpaque
        bar.tintColor = .headerText
        bar.placeholder = "Search"
        return bar
    }()
    
    // MARK: Properties
    
    private var state: SearchState = .idle
    private var searchDataRequest: Alamofire.DataRequest?
    weak var delegate: SearchLogicDelegate?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load", navigationItem)
        navigationItem.titleView = searchBar
    }

}

extension SearchLogicController: UISearchBarDelegate {
    
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
        
        switch state {
        case .idle:
            state = .began
            delegate?.searchLogicControllerDidBeginSearch(self)
            break
        default:
            break
        }
        
        if let request = searchDataRequest {
            request.cancel()
        }
        
//        if searchText.isEmpty {
//            print("Empty text")
//            displayViewController(for: .idle)
//            return
//        }
        
        let query = QueryBuilder()
            .search(withParameters: searchText)
            .build()
        
        let request = Service.execute(query, withUrl: Service.endpoints.search) { (result: SearchResult?, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.searchLogicController(self, didRecieveError: error)
                }
                return
            }
            
            guard let result = result else { return }
            
            guard result.count > 0 else {
                DispatchQueue.main.async {
                    self.delegate?.searchLogicControllerDidRecieveEmptyResult(self)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.searchLogicController(self, didRecieveResult: result)
            }
            
//            for (index, recipe) in result.recipes.enumerated() {
//                Service.request(recipe.image_url, complition: { (image) in
//                    guard let image = image else { return }
//                    recipe.image = image
//
////                    if let controller = self.currentViewController as? SearchResultViewController {
////                        controller.updateContent(at: index)
////                    }
//                })
//            }
            
            
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

extension SearchLogicController {
    
    enum SearchState {
        case idle, began, ended, cancelled
    }
}
































