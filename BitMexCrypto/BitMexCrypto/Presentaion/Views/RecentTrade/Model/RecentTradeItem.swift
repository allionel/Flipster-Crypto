//
//  RecentTradeItem.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

struct RecentTradeItem {
    let id: String
    let qty: Int
    let price: Double
    let tradeSide: TradeSide
    let timestamp: Date
    var didHighlight: Bool = false
}

extension RecentTradeItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RecentTrade.RecentTradeItem {
    var asLocalData: RecentTradeItem {
        .init(id: trdMatchID, qty: size ?? .zero, price: price, tradeSide: side, timestamp: timestamp)
    }
}

extension RecentTradeItem {
    static let mock: RecentTradeItem = .init(id: "asdasdasd", qty: 3328, price: 53245, tradeSide: .buy, timestamp: .init())
}
