//
//  WebSocketStreamError.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public enum WebSocketStreamError: String, Error {
    case urlIsNotValid
    case configurationIsNotInitialized
    case failToSendMessage
    case decodingFialed
    case encodingFialed
    case stringToDataConvertingFaild
    case dataToStringConvertingFaild
    case unkown
}

extension WebSocketStreamError {
    var description: String {
        rawValue.titleCase
    }
}

extension Error where Self == WebSocketStreamError {
    public var localizedDescription: String {
        self.description
    }
}
