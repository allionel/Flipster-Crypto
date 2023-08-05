//
//  Instrument.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public struct Instrument: Decodable, Equatable {
    public let table: SubscriptionTopic
    public let action: BitmexAction
    public let data: [InstrumentItem]
}

public struct InstrumentItem: Decodable, Equatable {
    public let symbol: String
    public let volume: Int?
    public let totalVolume: Int?
    public let openValue: Int?
    public let lastPrice: Double?
    public let fairPrice: Double?
    public let markPrice: Double?
    public let bidPrice: Double?
    public let midPrice: Double?
    public let askPrice: Double?
    public let impactBidPrice: Double?
    public let impactMidPrice: Double?
    public let impactAskPrice: Double?
}
