//
//  WebSocketStreamError.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum WebSocketStreamError: String, Error {
    case urlIsNotValid
    case configurationIsNotInitialed
    case failToSendMessage
    case decodingFialed
    case encodingFialed
    case unkown
}

extension WebSocketStreamError {
    var description: String { rawValue }
}

extension Error where Self == WebSocketStreamError {
    public var localizedDescription: String {
        self.description
    }
}
