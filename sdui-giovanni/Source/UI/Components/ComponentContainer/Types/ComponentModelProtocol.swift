//
//  ComponentModelProtocol.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import Foundation

protocol ComponentModelProtocol: Codable {
    var componentType: ComponentType { get }
}

protocol ActionModelProtocol: Codable {
    var actionType: ActionType { get }
}
