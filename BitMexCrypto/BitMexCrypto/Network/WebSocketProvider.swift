//
//  WebSocketProvider.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation
import Combine

public protocol WebSocketProvider {
    associatedtype DataOutput
    associatedtype Provider: AsyncSequence
    func subscribe(to topics: [SubscriptionTopic: String]) async throws
    func unsubscribe(from topics: [SubscriptionTopic: String]) async throws
    var messagePublisher: AnyPublisher<DataOutput, WebSocketError> { get }
}

protocol WebSocketMessaging {
    func requestString(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> String
    func requestData(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> Data
}

final class BitMexWebSocket<Provider: WebSocketStream, DataOutput: Decodable> where Provider.Element == SocketElement {
    private let webSocketStream: Provider
    private let messageSender: PassthroughSubject<DataOutput, WebSocketError> = .init()
    
    var messagePublisher: AnyPublisher<DataOutput, WebSocketError> {
        messageSender.eraseToAnyPublisher()
    }

    init(webSocketStream: Provider) {
        self.webSocketStream = webSocketStream
    }
    
    private func sendSocketStreamIteratedOutput() async throws {
        do {
            for try await message in webSocketStream.dropFirst(2){
                switch message {
                case .string(let message):
                    let data: DataOutput = try message.modelObject()
                    messageSender.send(data)
                case .data(let data):
                    let data: DataOutput = try data.jsonString().modelObject()
                    messageSender.send(data)
                default:
                    throw WebSocketError.socketMessageIsUndefined
                }
            }
        }
        catch {
            messageSender.send(completion: .failure(error.asWebSocketError))
            throw error.asWebSocketError
        }
    }
}

extension BitMexWebSocket: WebSocketProvider {
    func subscribe(to topics: [SubscriptionTopic : String]) async throws {
        let message =  try requestString(.subscribe, topics: topics)
        try await webSocketStream.sendMessage(message)
        Debugger.print("Socket subscribes to: ", topics)
        try await sendSocketStreamIteratedOutput()
    }
    
    func unsubscribe(from topics: [SubscriptionTopic : String]) async throws {
        let message = try requestString(.unsubscribe, topics: topics)
        try await webSocketStream.sendMessage(message)
        Debugger.print("Socket subscribes to: ", topics)
        webSocketStream.disconnect()
    }
}

extension BitMexWebSocket: WebSocketMessaging {
    func requestString(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> String {
        let args = topics.map { "\($0):\($1)" }
        let request = SocketRequest(op: operation, args: args)
        return try request.jsonString()
    }
    
    func requestData(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> Data {
        let args = topics.map { "\($0):\($1)" }
        let request = SocketRequest(op: operation, args: args)
        let str = try request.jsonString()
        return str.data(using: .utf8)!
    }
}
