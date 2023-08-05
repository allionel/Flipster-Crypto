//
//  TradeSideType.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum TradeSideType: String, Decodable {
    case buy
    case sell
    
    public var title: String {
        rawValue.capitalized
    }
}
