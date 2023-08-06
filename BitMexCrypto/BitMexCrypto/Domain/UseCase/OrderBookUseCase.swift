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
    var messagePublisher: AnyPublisher<OrderBook, Never> { get }
}

public final class OrderBookUseCaseImp<Repository: OrderBookRepository>: ObservableObject where Repository.DataOutput == OrderBook {
    private let repository: Repository
    var bag: Set<AnyCancellable> = .init()
    public var messagePublisher: AnyPublisher<OrderBook, Never> {
        $msg.eraseToAnyPublisher()
    }
    @Published var msg: OrderBook = .empty
    public init(repository: Repository) {
        self.repository = repository
    }
}

extension OrderBookUseCaseImp: OrderBookUseCase {
    public func subscribeToOrderBookL2(with symbol: SubscriptionSymbol) throws {
      
            try repository.subscribeToOrderBookL2(with: symbol.name)
            repository.messagePublisher.sink { res in
                
            } receiveValue: { data in
                self.msg = data
            }.store(in: &bag)

       
        
    }
    
    public func unsubscribeFromOrderBookL2(with symbol: SubscriptionSymbol) async throws {
        try await repository.unsubscribeFromOrderBookL2(with: symbol.name)
    }
}
