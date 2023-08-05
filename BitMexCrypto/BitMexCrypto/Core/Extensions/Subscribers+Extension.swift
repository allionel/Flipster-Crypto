//
//  Subscribers+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Combine

extension Subscribers.Completion where Failure == WebSocketError {
    public var error: WebSocketError {
        switch self {
        case .finished:
            return .unkown
        case .failure(let error):
            return error
        }
    }
}
