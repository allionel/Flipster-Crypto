//
//  WebSocketError.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum WebSocketError: Error {
    case urlIsNotValid
    case configurationIsNotInitialized
    case failToSendMessage
    case decodingFialed
    case encodingFialed
    case stringToDataConvertingFailed
    case dataToStringConvertingFailed
    case failedReturnExpectedData
    case socketStreamIsNotReady
    case streamHasBeenCompleted
    case unkown
    case notDefined(Any)
}

extension WebSocketError {
    var description: String {
        switch self {
        case .notDefined(let data):
            return String(describing: data)
        default:
            return String(describing: self)
        }
    }
}

extension Error {
    public var asWebSocketError: WebSocketError {
        (self as? WebSocketError) ?? .notDefined(self)
    }
}
extension Error where Self == WebSocketError {
    public var localizedDescription: String {
        self.description
    }
}

