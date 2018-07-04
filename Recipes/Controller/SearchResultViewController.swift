//
//  SearchResultViewController.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 02/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .background
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var result: SearchResult
    
    init(searchResult result: SearchResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
        
        print("Result count", result.count)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        setupSubviews()
    }
    
    
    
    func updateContent(at row: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SearchResultCell else { return }
        let recipe = result.recipes[row]
        cell.recipeImageView.image = recipe.image
        cell.titleLabel.text = recipe.title
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SearchResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        cell.reset()
        guard let image = result.recipes[indexPath.row].image else { return cell }
        cell.recipeImageView.image = image
        cell.titleLabel.text = result.recipes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
}

extension SearchResultViewController: UITableViewDelegate {
    
    
}
