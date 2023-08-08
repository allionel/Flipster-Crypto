//
//  SocketRequest.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public struct SocketRequest: Encodable {
    public let op: BitMexOperation
    public let args: [String]
}
