//
//  SocketRequest.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public struct SocketRequest: Encodable {
    public let op: String
    public let args: [String]
}

extension SocketRequest {
    public func jsonString() throws -> String {
        guard let encoded = try? JSONEncoder().encode(self),
              let json = String(data: encoded, encoding: .utf8) else {
            throw WebSocketStreamError.encodingFialed
        }
        return json
    }
}
