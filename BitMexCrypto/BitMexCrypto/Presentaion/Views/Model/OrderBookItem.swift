//
//  OrderBookItem.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

struct OrderBookItem {
    let qty: Double
    let price: Double
    let tradeSide: TradeSide
}

extension OrderBookItem {
    static let mock: OrderBookItem = .init(qty: 24, price: 53245, tradeSide: .buy)
}
