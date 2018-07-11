
import UIKit

class SearchErrorController: UIViewController {
    
    let headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .textColor
        label.text = "Woops!"
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .textColor
        label.text = "Something went wrong, please try again."
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupSubviews()
    }
    
    private func setupSubviews() {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, bodyLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
