//
//  CustomCell.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

class CustomCell: UITableViewCell {
    
    // MARK: - PUBLIC PROPERTIES
    
    static let reuseIdentifier: String = .init(describing: CustomCell.self)
    
    private(set) var view: UIView? {
        didSet {
            constrainUI()
        }
    }
    
    // MARK: - INITIALIZERS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC METHODS
    
    func setup(view: UIView) {
        self.view = view
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func constrainUI() {
        guard let view else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.subviews.forEach { $0.removeFromSuperview() }
        NSLayoutConstraint.deactivate(contentView.constraints)
        contentView.addSubview(view)
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomConstraint
        ])
    }
}
