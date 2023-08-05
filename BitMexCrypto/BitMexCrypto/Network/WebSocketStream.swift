//
//  WebSocketStream.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

final class WebSocketStream: AsyncSequence {
    typealias Element = URLSessionWebSocketTask.Message
    typealias AsyncWebSocketStream = AsyncThrowingStream<Element, Error>
    typealias AsyncIterator = AsyncWebSocketStream.Iterator
    
    private var stream: AsyncWebSocketStream?
    private var continuation: AsyncWebSocketStream.Continuation?
    private var socket: URLSessionWebSocketTask?
    
    init(url: String, session: URLSession = URLSession.shared) {
        guard let url = URL(string: url) else {
            Debugger.print(WebSocketStreamError.urlIsNotValid.description, type: .error)
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
        guard let stream else {
            fatalError("stream was not initialized")
        }
        socket?.resume()
        tryWithError(subscribeMessages)
        return stream.makeAsyncIterator()
    }
    
    func sendMessage(_ message: String) async throws {
        let socketMessage = Element.string(message)
        try await socket?.send(socketMessage)
    }
    
    private func subscribeMessages() throws {
        guard let continuation else {
            throw WebSocketStreamError.configurationIsNotInitialized
        }
        socket?.receive { [unowned self] result in
            switch result {
            case .success(let message):
                continuation.yield(message)
                tryWithError(subscribeMessages)
            case .failure(let error):
                continuation.finish(throwing: error)
            }
        }
    }
}
