//
//  Query.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 02/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import Foundation

typealias Operation = String

class Query {
    
    let operations: [Operation: String]
    
    init(operations: [Operation: String]) {
        self.operations = operations
    }
}
