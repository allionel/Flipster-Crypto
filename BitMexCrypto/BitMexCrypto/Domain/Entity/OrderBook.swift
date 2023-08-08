//
//  OrderBook.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public struct OrderBook: Decodable, Equatable {
    public let table: SubscriptionTopic?
    public let action: BitmexAction?
    public let data: [OrderBook.OrderBookItem]
}

extension OrderBook {
    public struct OrderBookItem: Decodable {
        public let symbol: String
        public let id: Int
        public let side: TradeSide
        public let size: Int?
        public let price: Double
        public let timestamp: Date
    }
}

extension OrderBook.OrderBookItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: OrderBook.OrderBookItem, rhs: OrderBook.OrderBookItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}


