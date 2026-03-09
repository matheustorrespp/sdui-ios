import UIKit

class CardComponentView: UIView, ComponentView {
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: ComponentViewDelegate?
    
    // MARK: - PRIVATE PROPERTIES
    
    private let model: CardComponentModel
    private let cardCornerRadius: CGFloat = 16
    private let actionFactory: ActionFactory = .init()
    
    // MARK: - UI
    
    /// Container que recebe a sombra (não pode ter clipsToBounds)
    private lazy var cardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = cardCornerRadius
        
        // Sombra suave
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        
        return view
    }()
    
    /// Container interno que faz o clip do conteúdo (imagem etc.)
    private lazy var contentClipView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = cardCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .systemGray5
        return view
    }()
    
    /// Gradiente sutil sobre a parte inferior da imagem
    private lazy var imageOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = model.title
        view.font = .boldSystemFont(ofSize: CGFloat(model.titleFontSize ?? 18))
        view.textColor = .init(hex: model.titleColor ?? "#1A1A1A")
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = model.text
        view.font = .systemFont(ofSize: CGFloat(model.textFontSize ?? 14))
        view.textColor = .init(hex: model.textColor ?? "#8A8A8E")
        view.numberOfLines = 0
        return view
    }()
    
    /// Stack somente para os labels (título + subtítulo) com padding horizontal
    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        return stack
    }()
    
    /// Stack principal: imagem + bloco de textos
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, textStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - INITIALIZERS
    
    init(model: CardComponentModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
        loadImage()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyImageOverlayGradient()
        // Melhora a performance da sombra definindo o shadowPath
        cardContainer.layer.shadowPath = UIBezierPath(
            roundedRect: cardContainer.bounds,
            cornerRadius: cardCornerRadius
        ).cgPath
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupView() {
        backgroundColor = .clear
        createViewHierarchy()
        constrainUI()
    }
    
    private func createViewHierarchy() {
        addSubview(cardContainer)
        cardContainer.addSubview(contentClipView)
        contentClipView.addSubview(mainStack)
        imageView.addSubview(imageOverlayView)
    }
    
    private func constrainUI() {
        NSLayoutConstraint.activate([
            // Card container com margem horizontal para a sombra respirar
            cardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cardContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            cardContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            cardContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // Clip view preenche o container
            contentClipView.topAnchor.constraint(equalTo: cardContainer.topAnchor),
            contentClipView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
            contentClipView.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor),
            contentClipView.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor),
            
            // Stack preenche o clip view
            mainStack.topAnchor.constraint(equalTo: contentClipView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentClipView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentClipView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentClipView.bottomAnchor),
            
            // Altura fixa da imagem
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Overlay gradiente na imagem
            imageOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imageOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageOverlayView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    /// Aplica um gradiente transparente → preto sutil na parte inferior da imagem
    private func applyImageOverlayGradient() {
        // Remove gradientes antigos para evitar duplicação
        imageOverlayView.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        gradient.frame = imageOverlayView.bounds
        gradient.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.15).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        imageOverlayView.layer.addSublayer(gradient)
    }
    
    private func loadImage() {
        if let path = Bundle.main.path(forResource: model.imageName, ofType: "png"),
           let image = UIImage(contentsOfFile: path) {
            imageView.image = image
        }
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cardContainer.addGestureRecognizer(tap)
        cardContainer.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        doAction()
    }
    
    private func doAction() {
        guard let action = actionFactory.makeAction(from: model.action) else { return }
        delegate?.didSelect(self, with: action)
    }
}
