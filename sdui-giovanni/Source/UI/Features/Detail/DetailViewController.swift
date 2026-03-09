//
//  DetailViewController.swift
//  sdui-giovanni
//
//  Created on 09/03/26.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - MODEL

    struct ViewModel {
        let imageName: String
        let title: String
        let text: String
    }

    // MARK: - PRIVATE PROPERTIES

    private let model: ViewModel

    // MARK: - UI

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Image

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        return iv
    }()

    /// Gradiente escuro na base da imagem para dar contraste com o conteúdo abaixo
    private lazy var imageGradientOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    // MARK: Text content card

    private lazy var textContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 16
        return view
    }()

    /// Pill decorativa no topo do container (drag indicator style)
    private lazy var pillView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 2.5
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = model.title
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(hex: "#1A1A1A")
        label.numberOfLines = 0
        return label
    }()

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#E5E5EA")
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = model.text
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: "#636366")
        label.numberOfLines = 0

        // Melhora legibilidade com line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedText = NSAttributedString(
            string: model.text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor(hex: "#636366")
            ]
        )
        label.attributedText = attributedText

        return label
    }()

    // MARK: Back button

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white

        button.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()

    // MARK: - INITIALIZERS

    init(model: ViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
        loadImage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyImageGradient()
    }

    override var prefersStatusBarHidden: Bool { true }

    // MARK: - SETUP

    private func setupView() {
        createViewHierarchy()
        constrainUI()
    }

    private func createViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(imageView)
        contentView.addSubview(imageGradientOverlay)
        contentView.addSubview(textContainerView)

        textContainerView.addSubview(pillView)
        textContainerView.addSubview(titleLabel)
        textContainerView.addSubview(dividerView)
        textContainerView.addSubview(textLabel)

        view.addSubview(backButton) // Fora do scroll para ficar fixo
    }

    private func constrainUI() {
        let imageHeight: CGFloat = UIScreen.main.bounds.height * 0.45

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Image
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageHeight),

            // Gradient overlay (bottom 40% da imagem)
            imageGradientOverlay.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imageGradientOverlay.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageGradientOverlay.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageGradientOverlay.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.4),

            // Text container — sobrepõe a imagem em 24pt para o efeito "sheet"
            textContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -24),
            textContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // Pill
            pillView.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 12),
            pillView.centerXAnchor.constraint(equalTo: textContainerView.centerXAnchor),
            pillView.widthAnchor.constraint(equalToConstant: 40),
            pillView.heightAnchor.constraint(equalToConstant: 5),

            // Title
            titleLabel.topAnchor.constraint(equalTo: pillView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -24),

            // Divider
            dividerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: 24),
            dividerView.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -24),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            // Text
            textLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: 24),
            textLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -24),
            textLabel.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -40),

            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    // MARK: - PRIVATE METHODS

    private func loadImage() {
        if let path = Bundle.main.path(forResource: model.imageName, ofType: "png"),
           let image = UIImage(contentsOfFile: path) {
            imageView.image = image
        }
    }

    private func applyImageGradient() {
        imageGradientOverlay.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }

        let gradient = CAGradientLayer()
        gradient.frame = imageGradientOverlay.bounds
        gradient.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        imageGradientOverlay.layer.addSublayer(gradient)
    }

    // MARK: - ACTIONS

    @objc private func didTapBack() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
