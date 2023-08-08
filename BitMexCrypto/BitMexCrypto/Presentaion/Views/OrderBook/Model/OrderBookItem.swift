//
//  OrderBookItem.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

struct OrderBookItem {
    let id: Int
    let qty: Int
    let price: Double
    let tradeSide: TradeSide
    var didChange: Bool = false
}

extension OrderBookItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension OrderBook.OrderBookItem {
    var asLocalData: OrderBookItem {
        .init(id: id, qty: size ?? .zero, price: price, tradeSide: side)
    }
}

extension OrderBookItem {
    static let mock: OrderBookItem = .init(id: 1111, qty: 3328, price: 53245, tradeSide: .buy)
}
