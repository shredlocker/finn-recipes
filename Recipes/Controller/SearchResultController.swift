
import UIKit

class SearchResultController: UIViewController {
    
    enum HeaderViewState: Int {
        case visuable, hidden, appearing, disappearing
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delaysContentTouches = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var result = SearchResult.empty()
    
    var cellAnimator: UIViewPropertyAnimator!
    var contentAnimator: UIViewPropertyAnimator!
    
    let headerView: UIView
    var headerViewAnimator: UIViewPropertyAnimator!
    var headerViewState: HeaderViewState = .visuable
    var animationHeight: CGFloat = 0.0
    
    var transitionDelegate = TransitionDelegate()
    
    init(headerView: UIView) {
        self.headerView = headerView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        animationHeight = headerView.frame.height - 44
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: headerView.frame.height - 44, left: 0, bottom: 0, right: 0)
        
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
        let width = view.frame.width - 64
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCell else { return }
        guard let animator = cellAnimator else { return }
        animator.pausesOnCompletion = false
        if animator.isRunning {
            animator.addCompletion { (position) in
                self.createTransition(from: cell)
            }
            return
        }
        createTransition(from: cell)
        
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
        cellAnimator = UIViewPropertyAnimator(duration: 0.12, curve: .easeOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        })
        cellAnimator.pausesOnCompletion = true
        cellAnimator.startAnimation()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let animator = cellAnimator {
            animator.pausesOnCompletion = false
            animator.isReversed = true
            animator.startAnimation()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch headerViewState {
        case .visuable:
            hideNavBarIfNeeded(scrollView)
        case .disappearing:
            animateNavBar(scrollView)
        case .hidden:
            showNavBarIfNeeded(scrollView)
        case .appearing:
            animateNavBar(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch headerViewState {
        case .disappearing:
            headerViewState = .hidden
            continueAnimations()
        case .appearing:
            headerViewState = .visuable
            continueAnimations()
        default:
            return
        }
    }
}

extension SearchResultController {
        
    private func newAnimations() {
        headerViewAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
            self.headerView.transform = CGAffineTransform(translationX: 0, y: -self.animationHeight)
            self.headerView.subviews.forEach({ (view) in
                view.alpha = 0
            })
        })
        headerViewAnimator.pausesOnCompletion = true
        headerViewAnimator.pauseAnimation()
    }
    
    private func hideNavBarIfNeeded(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        let velocity = gesture.velocity(in: self.view)
        guard velocity.y < 0.0 else { return }
        
        if headerViewAnimator == nil {
            newAnimations()
        }
        
        headerViewState = .disappearing
        headerViewAnimator.isReversed = false
    }
    
    private func showNavBarIfNeeded(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        let velocity = gesture.velocity(in: self.view)
        guard velocity.y > 0.0 else { return }
        
        headerViewState = .appearing
        headerViewAnimator.isReversed = true
    }
    
    private func continueAnimations() {
        let durationRemaining = 1 - headerViewAnimator.fractionComplete
        if headerViewState == .hidden, durationRemaining > 0 {
            // new content insets
            let offset = collectionView.contentOffset.y
            let distance = animationHeight * durationRemaining
            contentAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                self.collectionView.contentOffset.y = offset + distance
            })
            contentAnimator.pauseAnimation()
            contentAnimator.continueAnimation(withTimingParameters: nil, durationFactor: durationRemaining)
        }
        headerViewAnimator.continueAnimation(withTimingParameters: nil, durationFactor: durationRemaining)
    }
    
    private func animateNavBar(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        let translation = gesture.translation(in: view)
        let direction: CGFloat = headerViewState == .appearing ? 1 :  -1
        let fraction = direction * translation.y / animationHeight
        guard fraction <= 1.0 else {
            switch headerViewState {
            case .appearing:
                headerViewState = .visuable
                continueAnimations()
            case .disappearing:
                headerViewState = .hidden
                continueAnimations()
            default:
                break
            }
            return
        }
        headerViewAnimator.fractionComplete = fraction
    }
    
    private func createTransition(from cell: SearchResultCell) {
        let frame = cell.contentView.convert(cell.contentView.frame, to: view)
        let transitionAnimator = TransitionAnimator(cell: cell, frame: frame)
        self.transitionDelegate.transitionAnimator = transitionAnimator
        
        if let recipe = cell.recipe {
            let objectController = ObjectViewController(recipe: recipe)
            objectController.transitioningDelegate = transitionDelegate
            present(objectController, animated: true)
        }
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}





























