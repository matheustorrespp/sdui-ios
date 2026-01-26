//
//  ComponentServiceFactory.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import Foundation

class ComponentServiceFactory {
    func getComponents() -> [[String: AnyCodable]] {
        guard let url = Bundle.main.url(forResource: "mock", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let components = try? JSONDecoder().decode([[String: AnyCodable]].self, from: data) else {
            return []
        }
        return components
    }
}
