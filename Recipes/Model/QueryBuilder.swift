
import Foundation

class QueryOperation {
    static let key = "key"
    static let search = "q"
    static let sort = "sort"
    static let page = "page"
    static let id = "rId"
}

class QueryBuilder {
    
    private var currentPage: Int = 0
    private var operations = [Operation: String]()
    
    init() {
        operations[QueryOperation.key] = "20df2dd77ca96c91466c41b355a10f48"
    }
    
    @discardableResult
    func id(_ id: String) -> QueryBuilder {
        operations[QueryOperation.id] = id
        return self
    }
    
    @discardableResult
    func search(withParameters parameters: String) -> QueryBuilder {
        operations[QueryOperation.search] = parameters
        return self
    }
    
    @discardableResult
    func sort(byOption option: SortOption) -> QueryBuilder {
        switch option {
        case .rating:
            operations[QueryOperation.sort] = "r"
            break
        case .trending:
            operations[QueryOperation.sort] = "t"
            break
        }
        
        return self
    }
    
    @discardableResult
    func page(withIndex index: Int) -> QueryBuilder {
        currentPage = index
        operations[QueryOperation.page] = "\(index)"
        return self
    }
    
    @discardableResult
    func page(byOption option: PageOption) -> QueryBuilder {
        switch option {
        case .next:
            operations[QueryOperation.page] = "\(currentPage + 1)"
            break
        case .previous:
            guard currentPage > 1 else { break }
            operations[QueryOperation.page] = "\(currentPage - 1)"
            break
        }
        
        return self
    }
    
    
    func build() -> Query {
        return Query(operations: operations)
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
