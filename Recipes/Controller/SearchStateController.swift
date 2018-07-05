
import UIKit

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
        navigationItem.titleView = searchLogicController.searchBar
        searchLogicController.delegate = self
        
        displayViewController(for: .none)
    }
    
//    @objc func handleTap(sender: UITapGestureRecognizer) {
//        print("Tap tap tap tap tap")
//
//        switch state {
//        case .result:
//            if let controller = currentViewController as? SearchResultController {
//                let location = sender.location(in: controller.tableView)
//                guard let recipe = controller.recipeForCell(at: location) else { return }
//
//            }
//            break
//
//        default:
//            break
//        }
//    }
    
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
    
    func searchLogicControllerShouldBeginSearch(_ searchLogicController: SearchLogicController) {
        print("Should begin search")
    }
    
    func searchLogicControllerDidBeginSearch(_ searchLogicController: SearchLogicController) {
        print("Did begin search")
    }
    
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveResult result: SearchResult) {
        print("Did recieve result")
        for (index, recipe) in result.recipes.enumerated() {
            Service.request(recipe.image_url, complition: { (image) in
                guard let image = image else { return }
                recipe.image = image

                if let controller = self.currentViewController as? SearchResultController {
                    controller.updateContent(at: index)
                }
            })
        }
        resultController.setResult(result)
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



extension SearchStateController {
    enum ViewState: Int {
        case result, none, empty, error
    }
}
