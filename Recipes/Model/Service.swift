//
//  Service.swift
//  Recipes
//
//  Created by Granheim Brustad , Henrik on 02/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit
import Alamofire

class Service {
    
    fileprivate static let api = URL(string: "https://food2fork.com/api/")
    
    static let endpoints = (search: URL(string: "search", relativeTo: api),
                            get: URL(string: "get", relativeTo: api))
    
    @discardableResult
    static func execute<T: Decodable>(_ query: Query, withUrl url: URL?, complition: @escaping (T) -> Void) -> Alamofire.DataRequest? {
        guard let url = url else { return nil }
        
        let request = Alamofire.request(url, method: .post, parameters: query.operations, encoding: URLEncoding.default, headers: nil)
        request.responseData { (response) in
            
            guard let data = response.value else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                complition(object)
                
            } catch let jsonError {
                print("Error decoding JSON,", jsonError)
            }
        }
        
        return request
    }
    
    @discardableResult
    static func request(_ imageUrl: URL?, complition: @escaping (UIImage?) -> Void) -> Alamofire.DataRequest? {
        guard let url = imageUrl else { return nil}
        
        let request = Alamofire.request(url)
        request.responseData { (response) in
            guard let data = response.data, let image = UIImage(data: data  ) else {
                complition(nil)
                return
            }
            
            complition(image)
        }
        
        return request
    }
    
}
