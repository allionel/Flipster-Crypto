//
//  TradeSide.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum TradeSide: String, Decodable {
    case buy = "Buy"
    case sell = "Sell"
    
    public var title: String {
        rawValue.capitalized
    }
}

extension TradeSide {
    public var isBuy: Bool {
        self == .buy
    }
    
    public var isSell: Bool {
        self == .sell
    }
}
