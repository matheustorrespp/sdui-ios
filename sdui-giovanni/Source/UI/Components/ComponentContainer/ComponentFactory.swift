//
//  ComponentFactory.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

class ComponentFactory {
    func makeComponent(component: [String: AnyCodable]) -> ComponentView? {
        guard let componentType = getComponentType(component) else {
            return nil
        }
        switch componentType {
        case .title:
            guard let model = decode(TitleComponentModel.self, component: component) else { return nil }
            return TitleComponentView(model: model)
        case .spacer:
            return nil
        case .button:
            return nil
        }
    }
    
    private func getComponentType(_ component: [String: AnyCodable]) -> ComponentType? {
        guard let type = component["componentType"]?.value as? String else {
            return nil
        }
        guard let componentType = ComponentType(rawValue: type) else {
            return nil
        }
        return componentType
    }
    
//    func makeAction(action: [String: AnyCodable]) -> ActionType? {
//        guard let actionType = getActionType(component) else {
//            return nil
//        }
//        switch actionType {
//        case .navigate:
//            return nil
//        }
//    }
    
//    private func getActionType(_ action: [String: AnyCodable]) -> ActionType? {
//        guard let type = component["actionType"]?.value as? String else {
//            return nil
//        }
//        guard let actionType = ActionType(rawValue: type) else {
//            return nil
//        }
//        return actionType
//    }
    
    private func decode<T: ComponentModelProtocol>(_ type: T.Type, component: [String: AnyCodable]?) -> T? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(component)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            if JSONSerialization.isValidJSONObject(jsonObject) {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
                return try? JSONDecoder().decode(T.self, from: jsonData)
            }
            return nil
        } catch {
            return nil
        }
    }
}
