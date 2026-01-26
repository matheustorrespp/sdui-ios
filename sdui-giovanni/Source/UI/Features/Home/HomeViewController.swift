//
//  HomeViewController.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

class HomeViewController: ComponentContainer {
    override func retrieveComponents() {
        view.backgroundColor = .white
        let mock = ComponentServiceFactory().getComponents()
        updateComponents(mock)
    }
    
    override func execute(action: ActionType, from component: any ComponentView) {
        super.execute(action: action, from: component)
        switch action {
        case .navigate:
            print("navigate")
        }
    }
}
