//
//  ViewController.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 29/06/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class SearchStateController: UIViewController {
    
    private var state: SearchState = .idle
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.keyboardAppearance = .dark
        bar.barStyle = .blackTranslucent
        bar.tintColor = .headerText
        bar.placeholder = "Search"
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        searchBar.delegate = self
        
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationItem.titleView = searchBar
        
        displayViewController(for: .idle)
    }
    
    private func displayViewController(for state: SearchState) {
        // Update class property state
        self.state = state
        
        switch state {
        case .idle:
            print("Idle state")
            add(SearchIdleController())
            break
        case .empty:
            print("Empty state")
            break
        case .result:
            print("Result state")
            break
        case .error:
            print("Error state")
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        searchBar.setShowsCancelButton(false, animated: true)
        if searchBar.canResignFirstResponder { searchBar.resignFirstResponder() }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searc button clicked!")
        searchBar.setShowsCancelButton(false, animated: true)
        if searchBar.canResignFirstResponder { searchBar.resignFirstResponder() }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Did end editing")
    }
}

extension SearchStateController {
    
    enum SearchState {
        case idle, empty, result, error
    }
}
