//
//  Int+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

public extension Int {
    var asString: String {
        "\(self)"
    }
}

extension Double {
    public var asAmountFormat: String {
        self.formatted(.currency(code: "USD"))
            .dropFirst()
            .toString
//        String(format: "%.2f", self)
    }
    
    public var asString: String {
        "\(self)"
    }
}

extension String {
    public var removedCurrecyFormat: String {
        guard let numberString = self.components(separatedBy: ".").first else { return "" }
        return String(format: "%g", Double(numberString) ?? .zero)
    }
}
