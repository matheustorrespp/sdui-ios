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
    
    override func execute(action: ActionModelProtocol, from component: any ComponentView) {
        super.execute(action: action, from: component)
        switch action.actionType {
        case .navigate:
            if let navigateAction = action as? NavigateActionModel {
                print("navigate to: \(navigateAction.route ?? "unknown")")
            }
        case .print:
            if let printAction = action as? PrintActionModel {
                print(printAction.content)
            }
        }
    }
}
