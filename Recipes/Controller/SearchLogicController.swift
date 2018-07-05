
import UIKit

protocol SearchLogicDelegate: class {
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveResult result: SearchResult)
    func searchLogicControllerDidRecieveEmptyResult(_ searchLogicController: SearchLogicController)
    func searchLogicController(_ searchLogicController: SearchLogicController, didRecieveError error: Error)
}

extension Notification {
    static let dismissKeyboard = Notification.Name("dismissKeyboard")
}

extension SearchLogicController {
    
    enum SearchState: Int {
        case idle, began, paused, ended, cancelled
    }
}

class SearchLogicController: UIViewController {

    // MARK: Subviews
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.keyboardAppearance = .dark
        bar.barStyle = .blackOpaque
        bar.tintColor = .headerText
        bar.placeholder = "Search"
        return bar
    }()
    
    // MARK: Properties
    
    weak var delegate: SearchLogicDelegate?
    
    private var currentDataTask: URLSessionDataTask?
    private var currentSearchText = ""
    
    // MARK: Implementation
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard), name: Notification.dismissKeyboard, object: nil)
    }
    
    @objc func dismissKeyboard() {
        dismiss(searchBar, hideCancel: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load", navigationItem)
        navigationItem.titleView = searchBar
    }
    
    private func dismiss(_ searchBar: UISearchBar, hideCancel cancel: Bool) {
        if searchBar.canResignFirstResponder {
            searchBar.setShowsCancelButton(!cancel, animated: true)
            searchBar.resignFirstResponder()
        }
    }

}

extension SearchLogicController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
        dismiss(searchBar, hideCancel: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searc button clicked!")
        dismiss(searchBar, hideCancel: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let dataTask = currentDataTask {
            dataTask.cancel()
        }
        
        if searchText.isEmpty {
            print("Empty text")
            return
        }
        
        let queryItems = QueryBuilder()
            .search(withParameters: searchText)
            .build()
        
        guard let searchURL = Service.endpoints.search else { return }
        guard var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true) else { return }
        components.queryItems = queryItems
        
        let dataTask = Service.request(components.url) { (result: SearchResult?, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.searchLogicController(self, didRecieveError: error)
                }
                return
            }

            guard let result = result else { return }

            guard result.count > 0 else {
                DispatchQueue.main.async {
                    self.delegate?.searchLogicControllerDidRecieveEmptyResult(self)
                }
                return
            }

            self.currentSearchText = searchText
            DispatchQueue.main.async {
                self.delegate?.searchLogicController(self, didRecieveResult: result)
            }
        }
        
        dataTask?.resume()
        currentDataTask = dataTask
    }
}
































