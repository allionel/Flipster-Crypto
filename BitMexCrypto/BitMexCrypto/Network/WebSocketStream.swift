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
    func sendData(_ data: Data) async throws
    func connect()
    func suspend()
    func disconnect()
}

final class WebSocketManager {
    typealias Element = SocketElement
    typealias AsyncWebSocketStream = AsyncThrowingStream<Element, Error>
    typealias AsyncIterator = AsyncWebSocketStream.Iterator
    
    private var stream: AsyncWebSocketStream?
    private var continuation: AsyncWebSocketStream.Continuation?
    private var socket: URLSessionWebSocketTask?
    
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
        guard let stream = stream else {
            fatalError("stream was not initialized")
        }
        socket?.resume()
        Task { try await subscribeMessages() }
        return stream.makeAsyncIterator()
    }
    
    private func subscribeMessages() async throws {
        guard let continuation else {
            throw WebSocketError.configurationIsNotInitialized
        }
        socket?.receive { [unowned self] result in
            switch result {
            case .success(let message):
                continuation.yield(message)
                Task { try await subscribeMessages() }
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
    
    func sendData(_ data: Data) async throws {
        Task {
            let socketData = Element.data(data)
            try await socket?.send(socketData)
        }
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
