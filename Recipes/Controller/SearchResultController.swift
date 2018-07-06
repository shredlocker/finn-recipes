
import UIKit

class SearchResultController: UIViewController {
    
    private enum NavigationBarState: Int {
        case showing, disappearing, hidden, appearing
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let table = UICollectionView(frame: .zero, collectionViewLayout: layout)
        table.delaysContentTouches = false
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var result = SearchResult.empty()
    
    private let margin: CGFloat = 16
    private var startOffset: CGFloat = 0
    private var previousTranslation: CGPoint = .zero
    
    private var cellAnimator: UIViewPropertyAnimator!
    private var barAnimator: UIViewPropertyAnimator!
    
    private var navigationBarState: NavigationBarState = .showing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        setupSubviews()
    }
    
    func updateContent(with searchResult: SearchResult) {
        self.result = searchResult
        collectionView.reloadData()
        
        for (index, recipe) in searchResult.recipes.enumerated() {
            let dataTask = Service.request(recipe.image_url, complition: { (image) in
                guard let image = image else { return }
                recipe.image = image
                
                DispatchQueue.main.async {
                    self.updateContent(at: index)
                }
            })
            dataTask?.resume()
        }
    }
    
    func updateContent(at item: Int) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? SearchResultCell else { return }
        let recipe = result.recipes[item]
        cell.updateContent(for: recipe)
    }

}

extension SearchResultController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        
        cell.reset()
        cell.recipe = result.recipes[indexPath.row]
        cell.updateContent(for: result.recipes[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.recipes.count
    }
}

extension SearchResultController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - (2 * (margin + 8))
//        let string = result.recipes[indexPath.item].title
//        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let frame = string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font : SearchResultCell.font], context: nil)
        
        return CGSize(width: width, height: width)// + ceil(frame.height) + 2 * 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: margin, bottom: 8, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select row at:", indexPath)
        
        NotificationCenter.default.post(name: Notification.dismissKeyboard, object: nil)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCell, let recipe = cell.recipe else { return }
        
        reverseAnimationIfNeeded()
        
//        let recipeController = RecipeViewController(recipe: recipe)
//        navigationController?.pushViewController(recipeController, animated: true)
//
//        let queryItems = QueryBuilder()
//            .id(recipe.ID)
//            .build()
//
//        guard let searchURL = Service.endpoints.get else { return }
//        guard var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true) else { return }
//        components.queryItems = queryItems
//
//        let dataTask = Service.request(components.url) { (result: RecipeResult?, error) in
//            guard let result = result else { return }
//            if let ingredients = result.recipe.ingredients {
//                DispatchQueue.main.async {
//                    recipeController.update(ingredients: ingredients)
//                }
//            }
//        }
//        dataTask?.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cellAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeOut) {
            cell.contentView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
        cellAnimator.pausesOnCompletion = true
        cellAnimator.startAnimation()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        reverseAnimationIfNeeded()
        
        startOffset = scrollView.contentOffset.y
        
        switch navigationBarState {
        case .showing:
            shouldHideNavigationBarIfNeeded(scrollView)
            break
        case .hidden:
            shouldShowNavigationBarIfNeeded(scrollView)
            break
        default:
            break
        }
        
        // can remove this and replace with internal scroll view things
        NotificationCenter.default.post(name: Notification.dismissKeyboard, object: nil)
        if canBecomeFirstResponder { becomeFirstResponder() }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let navHeight: CGFloat = 145
        
        switch navigationBarState {
        case .disappearing:
            let offset = scrollView.contentOffset.y - startOffset
            if offset > navHeight {
                didHideNavigationBar()
                return
            }
            
            barAnimator.fractionComplete = offset / navHeight
            break
            
        case .appearing:
            let offset = scrollView.contentOffset.y - startOffset
            if offset > navHeight {
                didHideNavigationBar()
                return
            }
            
            barAnimator.fractionComplete = offset / navHeight
            break
        default:
            break
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        switch navigationBarState {
        case .disappearing:
            didHideNavigationBar()
            barAnimator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0)
            let duration = 0.3 * (1.0 - barAnimator.fractionComplete)
            UIView.animate(withDuration: Double(duration)) {
                scrollView.contentInset = UIEdgeInsets.zero
            }
            break
        case .appearing:
            barAnimator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0)
        default:
            break
        }
        
    }
}

extension SearchResultController {
    
    private func shouldHideNavigationBarIfNeeded(_ scrollView: UIScrollView) {
        print("Should hide navogatopmbar")
        navigationBarState = .disappearing
        barAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
            self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -145)
            self.barAnimator.pauseAnimation()
        })
    }
    
    private func didHideNavigationBar() {
        navigationBarState = .hidden
    }
    
    private func shouldShowNavigationBarIfNeeded(_ scrollView: UIScrollView) {
        navigationBarState = .appearing
        barAnimator.isReversed = true
        barAnimator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0)
        barAnimator.pauseAnimation()
    }
    
    private func reverseAnimationIfNeeded() {
        guard let animator = cellAnimator else { return }
        animator.isReversed = !animator.isReversed
        animator.pausesOnCompletion = false
        animator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeOut), durationFactor: 0)
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -64),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}





























