//
//  WebSocketStream.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

typealias SocketElement = URLSessionWebSocketTask.Message

protocol WebSocketStream: AsyncSequence {
    associatedtype Element
    func sendMessage(_ message: String) async throws
    func sendData<T: Encodable>(_ data: T) async throws
    func connect() async
    func suspend()
    func disconnect()
}

final class WebSocketManager {
    typealias Element = SocketElement
    typealias AsyncWebSocketStream = AsyncThrowingStream<Element, Error>
    typealias AsyncIterator = AsyncWebSocketStream.Iterator
    
//    private var stream: AsyncWebSocketStream?
    private var continuation: AsyncWebSocketStream.Continuation?
    private var socket: URLSessionWebSocketTask?
    
    private lazy var stream: AsyncWebSocketStream = {
        return AsyncWebSocketStream { continuation in
            self.continuation = continuation
            self.continuation?.onTermination = { @Sendable [socket] _ in
                socket?.cancel()
            }
            tryWithError(subscribeMessages)
        }
    }()
    
    init(url: String, session: URLSession = URLSession.shared) {
        guard let url = URL(string: url) else {
            Debugger.print(WebSocketError.urlIsNotValid.description, type: .error)
            return
        }
        socket = session.webSocketTask(with: url)
        stream = .init { continuation in
            self.continuation = continuation
            self.continuation?.onTermination = { @Sendable [socket] _ in
                socket?.cancel()
            }
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        socket?.resume()
        tryWithError(subscribeMessages)
        return stream.makeAsyncIterator()
    }

    private func subscribeMessages() throws {
        guard let continuation else {
            throw WebSocketError.configurationIsNotInitialized
        }
        socket?.receive { [unowned self] result in
            switch result {
            case .success(let message):
                print(message)
                continuation.yield(message)
                tryWithError(subscribeMessages)
            case .failure(let error):
                continuation.finish(throwing: error)
            }
        }
    }
}

extension WebSocketManager: WebSocketStream {
    func sendMessage(_ message: String) async throws {
        Task {
            let socketMessage = Element.string(message)
            try await socket?.send(socketMessage)
        }
    }
    
    func sendData<T: Encodable>(_ data: T) async throws {
//        Task {
            let string = try data.jsonString()
            guard let data = string.data(using: .utf8) else {
                throw WebSocketError.stringToDataConvertingFailed
            }
            let socketData = Element.data(data)
            try await socket?.send(socketData)
//        }
    }
    
    func connect() {
        socket?.resume()
        Debugger.print("Socket has been resumed")
    }
    
    func suspend() {
        socket?.suspend()
        Debugger.print("Socket has been suspende")
    }
    
    func disconnect() {
        socket?.cancel(with: .goingAway, reason: nil)
        continuation?.finish()
        Debugger.print("Socket has been terminated")
    }
}
