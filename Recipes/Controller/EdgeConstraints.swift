//
//  EdgeConstraints.swift
//  AppStoreTransition
//
//  Created by Granheim Brustad , Henrik on 10/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class EdgeConstraints {
    
    var left, top, right, bottom: NSLayoutConstraint
    var constraints: [NSLayoutConstraint] {
        return [top, left, bottom, right]
    }
    
    public init(view: UIView, container: UIView, frame: CGRect) {
        top = view.topAnchor.constraint(equalTo: container.topAnchor, constant: frame.minY)
        left = view.leftAnchor.constraint(equalTo: container.leftAnchor, constant: frame.minX)
        bottom = view.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                                              constant: frame.maxY - container.frame.height)
        right = view.rightAnchor.constraint(equalTo: container.rightAnchor,
                                            constant: frame.maxX - container.frame.width)
    }
    
    public func constants(to value: CGFloat) {
        constraints.forEach { $0.constant = value }
    }
    
    public func toggleConstraints(_ value: Bool) {
        constraints.forEach { $0.isActive = value }
    }
    
    public func match(to frame: CGRect, container: UIView) {
        top.constant = frame.minY
        left.constant = frame.minX
        bottom.constant = frame.maxY - container.frame.height
        right.constant = frame.maxX - container.frame.width
    }
}
