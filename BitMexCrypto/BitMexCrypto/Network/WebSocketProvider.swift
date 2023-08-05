//
//  WebSocketProvider.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation
import class Combine.Future
import struct Combine.Deferred

public typealias RemoteResponse<T: Decodable> = Future<T, WebSocketError>

protocol WebSocketProvider {
    associatedtype Provider: AsyncSequence
    func subscribe<T: Decodable>(to topics: [SubscriptionTopic: String]) async -> Future<T, WebSocketError>?
    func unsubscribe(from topics: [SubscriptionTopic: String]) async throws
}

final class BitMexWebSocket<Provider: WebSocketStream> where Provider.Element == SocketElement {
    fileprivate let webSocketStream: Provider
    
    init(webSocketStream: Provider) {
        self.webSocketStream = webSocketStream
    }
    
    fileprivate func request(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> String {
        let args = topics.map { "\($0):\($1)" }
        let request = SocketRequest(op: operation, args: args)
        return try request.jsonString()
    }
    
    fileprivate func socketStreamIteratedOutput<T: Decodable>(by message: String) async throws -> Future<T, WebSocketError>? {
        for try await message in webSocketStream {
            switch message {
            case .string(let message):
                let data: T = try message.modelObject()
                return .init { promiss in
                    promiss(.success(data))
                }
            case .data(let data):
                let data: T = try data.jsonString().modelObject()
                return .init { promiss in
                    promiss(.success(data))
                }
            default:
                return .init { promiss in
                    promiss(.failure(WebSocketError.failedReturnExpectedData))
                }
            }
        }
        return nil
    }
}

extension BitMexWebSocket: WebSocketProvider {
    func subscribe<T: Decodable>(to topics: [SubscriptionTopic : String]) async -> Future<T, WebSocketError>? {
        do {
            let message = try request(.subscribe, topics: topics)
            try await webSocketStream.sendMessage(message)
            Debugger.print("Socket subscribes to: ", topics)
            return try await socketStreamIteratedOutput(by: message)
        }
        catch {
            return Future { promiss in
                promiss(.failure(error.asWebSocketError))
            }
        }
    }
    
    func unsubscribe(from topics: [SubscriptionTopic : String]) async throws {
        do {
            let message = try request(.unsubscribe, topics: topics)
            Task {
                try await webSocketStream.sendMessage(message)
                Debugger.print("Socket subscribes to: ", topics)
                webSocketStream.disconnect()
            }
        } catch {
            throw error
        }
    }
}
