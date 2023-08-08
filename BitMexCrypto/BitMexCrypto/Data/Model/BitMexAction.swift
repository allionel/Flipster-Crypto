//
//  BitMexAction.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum BitmexAction: String, Decodable {
    case partial
    case delete
    case update
    case insert
}
