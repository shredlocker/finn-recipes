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
    func searchLogicControllerShouldBeginSearch(_ searchLogicController: SearchLogicController)
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
    
    var state: SearchState = .idle
    weak var delegate: SearchLogicDelegate?
    
    private var searchDataRequest: Alamofire.DataRequest?
    private var currentSearchText = ""
    
    // MARK: Implementation
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load", navigationItem)
        navigationItem.titleView = searchBar
    }
    
    func pauseSearch() {
        state = .paused
        dismiss(searchBar, hideCancel: true)
        if let text = searchBar.text {
            if text.isEmpty { searchBar.text = currentSearchText }
        }
    }
    
    private func dismiss(_ searchBar: UISearchBar, hideCancel cancel: Bool) {
        if searchBar.canResignFirstResponder {
            searchBar.setShowsCancelButton(!cancel, animated: true)
            searchBar.resignFirstResponder()
        }
    }

}

extension SearchLogicController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if state == .paused { state = .began }
        searchBar.setShowsCancelButton(true, animated: true)
        delegate?.searchLogicControllerShouldBeginSearch(self)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
        dismiss(searchBar, hideCancel: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searc button clicked!")
        dismiss(searchBar, hideCancel: true)
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
        
        if searchText.isEmpty {
            print("Empty text")
            return
        }
        
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
            
            self.currentSearchText = searchText
            DispatchQueue.main.async {
                self.delegate?.searchLogicController(self, didRecieveResult: result)
            }
        }
        
        searchDataRequest = request
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Did end editing")
    }
}

extension SearchLogicController {
    
    enum SearchState: Int {
        case idle, began, paused, ended, cancelled
    }
}
































