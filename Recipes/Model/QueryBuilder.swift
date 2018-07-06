
import Foundation

class QueryOperation {
    static let key = "key"
    static let search = "q"
    static let sort = "sort"
    static let page = "page"
    static let id = "rId"
}

class QueryBuilder {
    
    private var operations = [URLQueryItem]()
    
    init() {
        operations.append(URLQueryItem(name: QueryOperation.key, value: "548d3e4337da369330dc98f538956505"))
    }
    
    @discardableResult
    func id(_ id: String) -> QueryBuilder {
        operations.append(URLQueryItem(name: QueryOperation.id, value: id))
        return self
    }
    
    @discardableResult
    func search(withParameters parameters: String) -> QueryBuilder {
        operations.append(URLQueryItem(name: QueryOperation.search, value: parameters))
        return self
    }
    
    @discardableResult
    func sort(byOption option: SortOption) -> QueryBuilder {
        switch option {
        case .rating:
            operations.append(URLQueryItem(name: QueryOperation.sort, value: "r"))
            break
        case .trending:
            operations.append(URLQueryItem(name: QueryOperation.sort, value: "t"))
            break
        }
        
        return self
    }
    
    @discardableResult
    func page(withIndex index: Int) -> QueryBuilder {
        operations.append(URLQueryItem(name: QueryOperation.page, value: "\(index)"))
        return self
    }
    
    func build() -> [URLQueryItem] {
        return operations
    }
}

extension QueryBuilder {
    
    enum SortOption {
        case rating
        case trending
    }
    
    enum PageOption {
        case next
        case previous
    }
}
