//
//  OrderBookRepository.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Combine

public protocol OrderBookRepository {
    associatedtype DataOutput
    func subscribeToOrderBookL2(with symbol: String) async throws
    func unsubscribeFromOrderBookL2(with symbol: String) async throws
    var messagePublisher: AnyPublisher<DataOutput, WebSocketError> { get }
}

public final class OrderBookRepositoryImp<Provider: WebSocketProvider, DataOutput: Decodable>: CancellableBagHolder where Provider.DataOutput == DataOutput {
    private let provider: Provider
    private let messageSender: PassthroughSubject<DataOutput, WebSocketError> = .init()
    
    public var canellables: Set<AnyCancellable> = .init()
    public var messagePublisher: AnyPublisher<DataOutput, WebSocketError> {
        messageSender.eraseToAnyPublisher()
    }
    
    public init(provider: Provider) {
        self.provider = provider
    }
}

extension OrderBookRepositoryImp: OrderBookRepository {
    public func subscribeToOrderBookL2(with symbol: String) async throws  {
        provider.messagePublisher.sink { [weak self] in
            self?.messageSender.send(completion: .failure($0.error))
        } receiveValue: { [weak self] in
            self?.messageSender.send($0)
        }.store(in: &canellables)
        try await provider.subscribe(to: [.orderBookL2: symbol])
    }
    
    public func unsubscribeFromOrderBookL2(with symbol: String) async throws {
        try await provider.unsubscribe(from: [.orderBookL2: symbol])
    }
}
