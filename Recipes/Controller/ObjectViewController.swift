//
//  ObjectViewController.swift
//  AppStoreTransition
//
//  Created by Granheim Brustad , Henrik on 10/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class ObjectViewController: UIViewController {
    
    var containerViewConstraints: EdgeConstraints?
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Clear button"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageview = UIImageView(frame: .zero)
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.backgroundColor = .white
        imageView.image = recipe.image
        setupSubviews()
    }
    
    @objc func closeButtonPressed(sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func setupSubviews() {
        view.addSubview(imageView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width - 64),
           
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.widthAnchor.constraint(equalToConstant: 32)
            ])
    }
}
