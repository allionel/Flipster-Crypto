//
//  WebSocketProvider.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation
import Combine
import class Combine.Future
import struct Combine.Deferred
import struct Combine.AnyPublisher

public typealias RemoteResponse<T: Decodable> = PassthroughSubject<T, WebSocketError>

public protocol WebSocketProvider {
    associatedtype DataOutput
    associatedtype Provider: AsyncSequence
    func subscribe(to topics: [SubscriptionTopic: String])  throws
    func unsubscribe(from topics: [SubscriptionTopic: String]) async throws
    var messagePublisher: AnyPublisher<DataOutput, Never> { get }
}

protocol WebSocketMessaging {
    associatedtype DataType
    func requestString(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> String
    func requestData(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) -> Data
}

final class BitMexWebSocket<Provider: WebSocketStream, DataOutput: Decodable>: ObservableObject where Provider.Element == SocketElement {
    typealias DataType = Encodable
//    typealias DataOutput = Decodable
    fileprivate let webSocketStream: Provider
    var messagePublisher: AnyPublisher<DataOutput, Never> {
        $msg.compactMap{$0}.filter{($0 as! OrderBook).action != .delete} .eraseToAnyPublisher()
    }
    @Published var msg: DataOutput? = .empty
    init(webSocketStream: Provider) {
        self.webSocketStream = webSocketStream
        
    }
    
    private func listenToMessage() async throws {
        for try await message in webSocketStream.dropFirst(2){
            switch message {
            case .string(let message):
                do {
                    let data: DataOutput = try message.modelObject()
                    msg = data
                } catch {
                    print(error)
                }
                
            case .data(let data):
                let data: DataOutput = try data.jsonString().modelObject()
                msg = data
            default:
                break
            }
        }
    }
//    fileprivate func socketStreamIteratedOutput<T: Decodable>(by message: String) async throws -> Future<T, WebSocketError>? {
//        for try await message in webSocketStream {
//            switch message {
//            case .string(let message):
//                let data: T = try message.modelObject()
//                return .init { promiss in
//                    promiss(.success(data))
//                }
//            case .data(let data):
//                let data: T = try data.jsonString().modelObject()
//                return .init { promiss in
//                    promiss(.success(data))
//                }
//            default:
//                return .init { promiss in
//                    promiss(.failure(WebSocketError.failedReturnExpectedData))
//                }
//            }
//        }
//        return nil
//    }
}

extension BitMexWebSocket: WebSocketProvider {
    func subscribe(to topics: [SubscriptionTopic : String]) throws  {
        
        
            Task {
              
                let message =  try requestString(.subscribe, topics: topics)
                try await webSocketStream.sendMessage(message)
                Debugger.print("Socket subscribes to: ", topics)
                try await listenToMessage()
            
              
        }
        
    }
    
    func unsubscribe(from topics: [SubscriptionTopic : String]) async throws {
        do {
            let message = try requestString(.unsubscribe, topics: topics)
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

extension BitMexWebSocket: WebSocketMessaging {
    func requestString(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) throws -> String {
        let args = topics.map { "\($0):\($1)" }
        let request = SocketRequest(op: operation, args: args)
        return try request.jsonString()
    }
    
    func requestData(_ operation: BitMexOperation, topics: [SubscriptionTopic: String]) -> Data {
        let args = topics.map { "\($0):\($1)" }
        let request = SocketRequest(op: operation, args: args)
        let str = try! request.jsonString()
        return str.data(using: .utf8)!
    }
}
