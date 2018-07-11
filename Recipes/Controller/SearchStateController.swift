
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
    
    let headerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .headerViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    init() {
        searchLogicController = SearchLogicController()
        super.init(nibName: nil, bundle: nil)
        searchLogicController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        print("Status bar frame", UIApplication.shared.statusBarFrame)
        
        emptyController = SearchEmptyController()
        errorController = SearchErrorController()
        resultController = SearchResultController(headerView: headerView)
        idleController = SearchIdleController()
        
        setupHeaderView()
        displayViewController(for: .none)
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        add(searchLogicController)
        headerView.addSubview(searchLogicController.view)
        
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 96),
            
            searchLogicController.view.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            searchLogicController.view.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            searchLogicController.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchLogicController.view.heightAnchor.constraint(equalToConstant: 44 + 16)
        ])
        
        searchLogicController.didMove(toParentViewController: self)
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
    
    func searchLogicControllerDidRecieveEmptyResult(_ searchLogicController: SearchLogicController) {
        print("Empty result")
        displayViewController(for: .empty)
    }
    
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveError error: Error) {
        print(error)
        displayViewController(for: .error)
    }
}




























