//
//  WebSocketProvider.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation
import class Combine.Future

protocol WebSocketProvider {
    func subscribe(to topics: [SubscriptionTopic: String]) async throws -> Future<WebSocketStream, Error>
    func unsubscribe(from topics: [SubscriptionTopic: String]) async throws -> Future<WebSocketStream, Error>
}

final class WebSocketManager {
    fileprivate let webSocketStream: WebSocketStream
    
    init(webSocketStream: WebSocketStream) {
        self.webSocketStream = webSocketStream
    }
    
    fileprivate func request(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> String {
        let args = topics.map { "\($0):\($1)" }
        let request = SocketRequest(op: operation, args: args)
        return try request.jsonString()
    }
}

extension WebSocketManager: WebSocketProvider {
    func subscribe(to topics: [SubscriptionTopic : String]) async throws -> Future<WebSocketStream, Error> {
        do {
            let message = try request(.subscribe, topics: topics)
            Task {
                try await webSocketStream.sendMessage(message)
                Debugger.print("Subscribe to: ", topics)
            }
            return Future { [weak self] promiss in
                guard let self else { return }
                promiss(.success(webSocketStream))
            }
        } catch {
            return Future { promiss in
                promiss(.failure(error))
            }
        }
    }
    
    func unsubscribe(from topics: [SubscriptionTopic : String]) async throws -> Future<WebSocketStream, Error> {
        do {
            let message = try request(.unsubscribe, topics: topics)
            Task {
                try await webSocketStream.sendMessage(message)
                Debugger.print("Unsubscribe from: ", topics)
            }
            return Future { [weak self] promiss in
                guard let self else { return }
                promiss(.success(webSocketStream))
            }
        } catch {
            return Future { promiss in
                promiss(.failure(error))
            }
        }
    }
}
