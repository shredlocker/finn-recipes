//
//  SearchRestultCell.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 03/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    static let identifier = "searchCell"
    
    var recipe: Recipe?
    
    let recipeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradientView: GradientView = {
        let view = GradientView(colors: [UIColor(white: 1.0, alpha: 0).cgColor, UIColor.background.cgColor])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        clipsToBounds = true
        setupSubviews()
    }
    
    func reset() {
        recipe = nil
        recipeImageView.image = nil
        titleLabel.text = nil
        gradientView.isHidden = true
    }
    
    private func setupSubviews() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            recipeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 64),
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
