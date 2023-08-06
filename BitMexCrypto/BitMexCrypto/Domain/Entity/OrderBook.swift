//
//  OrderBook.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public struct OrderBook: Decodable, Equatable, Encodable {
    public let table: SubscriptionTopic
    public let action: BitmexAction
    public let data: [OrderBookItem]
}

public struct OrderBookItem: Decodable, Encodable {
    public let symbol: String
    public let id: Int
    public let side: TradeSide
    public let size: Int?
    public let price: Double
    public let timestamp: Date
}

extension OrderBookItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: OrderBookItem, rhs: OrderBookItem) -> Bool {
        lhs.id == rhs.id
    }
}


