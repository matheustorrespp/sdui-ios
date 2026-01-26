//
//  Collection+Extensions.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
