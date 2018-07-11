
import UIKit

extension SearchStateController {
    enum ViewState: Int {
        case result, none, empty, error
    }
}

class SearchStateController: UIViewController {
    
    private var state: ViewState = .none
    
    private let searchLogicController: SearchLogicController
    // State controllers
    private var emptyController: SearchEmptyController!
    private var errorController: SearchErrorController!
    private var resultController: SearchResultController!
    private var idleController: SearchIdleController!
    private var currentViewController: UIViewController?
    
    init() {
        searchLogicController = SearchLogicController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.titleView = searchLogicController.searchBar
        searchLogicController.delegate = self
        
        emptyController = SearchEmptyController()
        errorController = SearchErrorController()
        resultController = SearchResultController()
        idleController = SearchIdleController()
        
        displayViewController(for: .none)
    }
    
    private func displayViewController(for state: ViewState) {
        if let child = currentViewController {
            child.remove()
        }
        
        // Update class property
        self.state = state
        
        switch state {
        case .none:
            setViewController(idleController)
            break
        case .empty:
            setViewController(emptyController)
            break
        case .result:
            setViewController(resultController)
            break
        case .error:
            setViewController(errorController)
            break
        }
    }
    
    private func setViewController(_ viewController: UIViewController) {
        currentViewController = viewController
        add(viewController)
    }
}

extension SearchStateController: SearchLogicDelegate {
    
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveResult result: SearchResult) {
        print("Did recieve result")
        resultController.updateContent(with: result)
        if state != .result { displayViewController(for: .result) }
    }
    
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveError error: Error) {
        print(error)
        displayViewController(for: .error)
    }
    
    func searchLogicControllerDidRecieveEmptyResult(_ searchLogicController: SearchLogicController) {
        print("Empty result")
        displayViewController(for: .empty)
    }
}
