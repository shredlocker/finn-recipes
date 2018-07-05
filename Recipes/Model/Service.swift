

import UIKit

class Service {
    
    fileprivate static let api = URL(string: "https://food2fork.com/api/")
    
    static let endpoints = (search: URL(string: "search", relativeTo: api),
                            get: URL(string: "get", relativeTo: api))
    
    static func request<T: Decodable>(_ url: URL?, complition: @escaping (T?, Error?) -> Void) -> URLSessionDataTask? {
        guard let url = url else { return nil }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                complition(object, nil)
                
            } catch let jsonError {
                print("Error decoding JSON,", jsonError)
            }
        }
        
        return dataTask
    }
    
    @discardableResult
    static func request(_ imageUrl: URL?, complition: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let url = imageUrl else { return nil}
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            complition(image)
        }
        
        return dataTask
        
    }
    
}
