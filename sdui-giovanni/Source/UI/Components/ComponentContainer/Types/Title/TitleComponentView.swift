//
//  TitleComponentView.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

class TitleComponentView: UIView, ComponentView {
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: ComponentViewDelegate?

    // MARK: - PRIVATE PROPERTIES
    
    private let model: TitleComponentModel
    
    // MARK: - UI
    
    private lazy var title: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = model.content
        view.font = .systemFont(ofSize: CGFloat(model.fontSize ?? 16))
        view.textColor = .init(hex: model.color ?? "#000000")
        return view
    }()
    
    // MARK: - INITIALIZERS
    
    init(model: TitleComponentModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
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
        addSubview(title)
    }
    
    private func constrainUI() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func doAction() {
        delegate?.didSelect(self, with: .navigate) //model.action
    }
}
