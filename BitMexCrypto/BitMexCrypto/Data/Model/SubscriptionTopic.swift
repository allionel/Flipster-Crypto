//
//  SubscriptionTopic.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum SubscriptionTopic: String, Decodable, Encodable {
    case orderBookL2
    case instrument
    case trade
}
