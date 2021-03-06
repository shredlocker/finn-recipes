
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = UINavigationController(rootViewController: SearchStateController())
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

