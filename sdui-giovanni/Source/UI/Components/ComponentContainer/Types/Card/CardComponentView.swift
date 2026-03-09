import UIKit

class CardComponentView: UIView, ComponentView {
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: ComponentViewDelegate?
    
    // MARK: - PRIVATE PROPERTIES
    
    private let model: CardComponentModel
    
    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = model.title
        view.font = .boldSystemFont(ofSize: CGFloat(model.titleFontSize ?? 18))
        view.textColor = .init(hex: model.titleColor ?? "#000000")
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = model.text
        view.font = .systemFont(ofSize: CGFloat(model.textFontSize ?? 14))
        view.textColor = .init(hex: model.textColor ?? "#666666")
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, textLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - INITIALIZERS
    
    init(model: CardComponentModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
        loadImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupView() {
        createViewHierarchy()
        constrainUI()
    }
    
    private func createViewHierarchy() {
        addSubview(stackView)
    }
    
    private func constrainUI() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func loadImage() {
        if let path = Bundle.main.path(forResource: model.imageName, ofType: "png"),
           let image = UIImage(contentsOfFile: path) {
            imageView.image = image
        }
    }
    
    private func doAction() {
        delegate?.didSelect(self, with: .navigate)
    }
}
