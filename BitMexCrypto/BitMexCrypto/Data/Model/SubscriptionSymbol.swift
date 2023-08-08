//
//  SubscriptionSymbol.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum SubscriptionSymbol: String {
    case xbtusd
}

extension SubscriptionSymbol {
    public var name: String {
        rawValue.uppercased()
    }
}
