//
//  ComponentView.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

protocol ComponentView: UIView {
    var delegate: ComponentViewDelegate? { get set }
    
    func componentContainer() -> ComponentContainer?
}

extension ComponentView {
    func componentContainer() -> ComponentContainer? {
        delegate?.componentContainer()
    }
}

protocol ComponentViewDelegate: UIViewController {
    func didSelect(_ component: ComponentView, with action: ActionType)
    func componentContainer() -> ComponentContainer?
}
