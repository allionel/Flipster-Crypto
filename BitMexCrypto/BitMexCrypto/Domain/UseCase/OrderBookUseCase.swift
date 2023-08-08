//
//  OrderBookUseCase.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Combine

public protocol OrderBookUseCase {
    func subscribeToOrderBookL2(with symbol: SubscriptionSymbol) async throws
    func unsubscribeFromOrderBookL2(with symbol: SubscriptionSymbol) async throws
    var messagePublisher: AnyPublisher<OrderBook, WebSocketError> { get }
}

public final class OrderBookUseCaseImp<Repository: OrderBookRepository>: CancellableBagHolder where Repository.DataOutput == OrderBook {
    private let repository: Repository
    private let messageSender: PassthroughSubject<OrderBook, WebSocketError> = .init()
    
    public var canellables: Set<AnyCancellable> = .init()
    public var messagePublisher: AnyPublisher<OrderBook, WebSocketError> {
        messageSender.eraseToAnyPublisher()
    }
    public init(repository: Repository) {
        self.repository = repository
    }
}

extension OrderBookUseCaseImp: OrderBookUseCase {
    public func subscribeToOrderBookL2(with symbol: SubscriptionSymbol) async throws {
        repository.messagePublisher.sink { [weak self] in
            self?.messageSender.send(completion: .failure($0.error))
        } receiveValue: { [weak self] in
            self?.messageSender.send($0)
        }.store(in: &canellables)
        try await repository.subscribeToOrderBookL2(with: symbol.name)
    }
    
    public func unsubscribeFromOrderBookL2(with symbol: SubscriptionSymbol) async throws {
        try await repository.unsubscribeFromOrderBookL2(with: symbol.name)
    }
}
