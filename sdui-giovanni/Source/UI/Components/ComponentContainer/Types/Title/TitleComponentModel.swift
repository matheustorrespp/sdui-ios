//
//  TitleComponentModel.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import Foundation

struct TitleComponentModel: ComponentModelProtocol {
    var componentType: ComponentType = .title
    
    let content: String
    let fontSize: Int?
    let color: String?
    
    let action: [String: AnyCodable]? // rename to typealias
    
//    func decode() throws {
//        self.action = ComponentFactory.makeAction()
//    }
}
