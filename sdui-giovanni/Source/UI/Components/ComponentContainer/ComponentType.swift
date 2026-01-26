//
//  ComponentType.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import Foundation

enum ComponentType: String, Codable {
    case title = "TITLE"
    case spacer = "SPACER"
    case button = "BUTTON"
}

enum ActionType: String, Codable {
    case navigate = "NAVIGATE"
}
