//
//  Optional+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

extension Optional {
    public var isNil: Bool {
        return self == nil
    }
}

public extension Optional where Wrapped == String {
    var isEmptyOrNull: Bool {
        self == nil || self!.isEmpty
    }
    
    var unwrapped: String {
        self ?? ""
    }
}
