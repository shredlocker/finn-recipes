
import UIKit

class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    convenience init(colors: [CGColor]) {
        self.init(frame: .zero)
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
}
