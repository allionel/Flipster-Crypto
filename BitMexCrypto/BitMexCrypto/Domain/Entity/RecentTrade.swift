//
//  RecentTrade.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public struct RecentTrade: Decodable, Equatable {
    public let table: SubscriptionTopic?
    public let action: BitmexAction?
    public let data: [RecentTrade.RecentTradeItem]
}

extension RecentTrade {
    public struct RecentTradeItem: Decodable {
        public let timestamp: Date
        public let symbol: String
        public let side: TradeSide
        public let size: Int?
        public let price: Double
        public let tickDirection: String
        public let trdMatchID: String
        public let grossValue: Int
        public let homeNotional: Double
        public let foreignNotional: Double
        public let trdType: String
    }
}

extension RecentTrade.RecentTradeItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(trdMatchID)
    }
    
    public static func == (lhs: RecentTrade.RecentTradeItem, rhs: RecentTrade.RecentTradeItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
