
import Foundation

typealias Operation = String

class Query {
    
    let operations: [Operation: String]
    
    init(operations: [Operation: String]) {
        self.operations = operations
    }
}
