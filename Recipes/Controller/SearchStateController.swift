
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
    private let emptyController: SearchEmptyController
    private let errorController: SearchErrorController
    private let resultController: SearchResultController
    private let idleController: SearchIdleController
    private var currentViewController: UIViewController?
    
    init() {
        searchLogicController = SearchLogicController()
        emptyController = SearchEmptyController()
        errorController = SearchErrorController()
        resultController = SearchResultController()
        idleController = SearchIdleController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.headerText]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .headerText
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = searchLogicController.searchBar
        searchLogicController.delegate = self
        
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
