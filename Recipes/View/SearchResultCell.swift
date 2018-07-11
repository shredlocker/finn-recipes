
import UIKit

class SearchResultView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(white: 0, alpha: 0.7)
        label.font = SearchResultCell.font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(imageView)
//        addSubview(effectView)
//        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
//
//            effectView.leftAnchor.constraint(equalTo: leftAnchor),
//            effectView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
//            effectView.rightAnchor.constraint(equalTo: rightAnchor),
//            effectView.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
//            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchResultCell: UICollectionViewCell {
    
    static let identifier = "searchCell"
    static let font: UIFont = .systemFont(ofSize: 24, weight: .bold)
    
    var recipe: Recipe?
    
    let searchResultView: SearchResultView = {
        let view = SearchResultView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 16
        setupSubviews()
    }
    
    func updateContent(for recipe: Recipe) {
        searchResultView.imageView.image = recipe.image
        searchResultView.titleLabel.text = recipe.title
    }
    
    func reset() {
        recipe = nil
        searchResultView.imageView.image = nil
        searchResultView.titleLabel.text = nil
    }
    
    private func setupSubviews() {
        contentView.addSubview(searchResultView)
        
        NSLayoutConstraint.activate([
            searchResultView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            searchResultView.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchResultView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            searchResultView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
