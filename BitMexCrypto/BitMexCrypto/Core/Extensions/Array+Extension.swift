//
//  Array+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

public extension Array where Element: Hashable {
    mutating func replace(_ element: Element) {
        guard let index = firstIndex(where: { $0.hashValue == element.hashValue }) else { return }
        self[index] =  element
    }
    
    mutating func remove(_ element: Element) {
        guard let index = firstIndex(where: { $0.hashValue == element.hashValue }) else { return }
        self.remove(at: index)
    }
}
