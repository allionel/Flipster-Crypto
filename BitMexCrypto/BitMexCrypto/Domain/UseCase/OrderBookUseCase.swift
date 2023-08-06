//
//  OrderBookUseCase.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation
import Combine

public protocol OrderBookUseCase {
//    associatedtype DataOutput
    func subscribeToOrderBookL2(with symbol: SubscriptionSymbol) throws
    func unsubscribeFromOrderBookL2(with symbol: SubscriptionSymbol) async throws
    var messagePublisher: PassthroughSubject<OrderBook, Error> { get }
}

public final class OrderBookUseCaseImp<Repository: OrderBookRepository> where Repository.DataOutput == OrderBook {
    private let repository: Repository
    var bag: Set<AnyCancellable> = .init()
    public var messagePublisher: PassthroughSubject<OrderBook, Error> = .init()
    public init(repository: Repository) {
        self.repository = repository
    }
}

extension OrderBookUseCaseImp: OrderBookUseCase {
    public func subscribeToOrderBookL2(with symbol: SubscriptionSymbol) throws {
        Task {
            try repository.subscribeToOrderBookL2(with: symbol.name)
            repository.messagePublisher.sink { res in
                self.messagePublisher.send(completion: .failure(WebSocketError.unkown))
            } receiveValue: { data in
                self.messagePublisher.send(data)
            }.store(in: &bag)

        }
        
    }
    
    public func unsubscribeFromOrderBookL2(with symbol: SubscriptionSymbol) async throws {
        try await repository.unsubscribeFromOrderBookL2(with: symbol.name)
    }
}
