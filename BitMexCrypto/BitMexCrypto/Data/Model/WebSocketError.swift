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
    case stringToDataConvertingFaild
    case dataToStringConvertingFaild
    case failedReturnExpectedData 
    case unkown
    case notDefined(String)
}

extension WebSocketError {
    var description: String {
        switch self {
        case .notDefined(let text):
            return text
        default:
            return String(describing: self)
        }
    }
}

extension Error {
    public var asWebSocketError: WebSocketError {
        (self as? WebSocketError) ?? .notDefined(self.localizedDescription)
    }
}
extension Error where Self == WebSocketError {
    public var localizedDescription: String {
        self.description
    }
}

