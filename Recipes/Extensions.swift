
import UIKit

extension SearchStateController {
    
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.insertSubview(child.view, belowSubview: headerView)
        child.didMove(toParentViewController: self)
    }
}

extension UIViewController {
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}

extension UIColor {
    
    static let headerViewColor = UIColor(red: 62, green: 71, blue: 86)
    static let background = UIColor(red: 3, green: 54, blue: 73)
    static let textColor = UIColor(red: 16, green: 25, blue: 54)
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}
