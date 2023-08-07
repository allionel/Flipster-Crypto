//
//  Strings+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: .main, comment: "")
    }
}

public extension String {
    var toAmount: Double {
        return Double(self) ?? .zero
    }
}

public extension Substring {
    var toString: String {
        String(self)
    }
}
