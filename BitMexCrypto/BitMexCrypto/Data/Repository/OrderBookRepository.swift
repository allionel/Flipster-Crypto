//
//  OrderBookRepository.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Combine

public protocol OrderBookRepository {
    associatedtype DataOutput
    func subscribeToOrderBookL2(with symbol: String) throws
    func unsubscribeFromOrderBookL2(with symbol: String) async throws
    var messagePublisher: PassthroughSubject<DataOutput, Error> { get }
    
    
}

public final class OrderBookRepositoryImp<Provider: WebSocketProvider, DataOutput: Decodable> where Provider.DataOutput == DataOutput {
    private let provider: Provider
    var bag: Set<AnyCancellable> = .init()
    public var messagePublisher: PassthroughSubject<DataOutput, Error> = .init()
    public init(provider: Provider) {
        self.provider = provider
    }
}

extension OrderBookRepositoryImp: OrderBookRepository {
    public func subscribeToOrderBookL2(with symbol: String) throws {
        Task {
            try provider.subscribe(to: [.orderBookL2: symbol])
            provider.messagePublisher.sink { res in
                self.messagePublisher.send(completion: .failure(WebSocketError.unkown))
            } receiveValue: { data in
                self.messagePublisher.send(data)
            }.store(in: &bag)
        }
    }
    
    public func unsubscribeFromOrderBookL2(with symbol: String) async throws {
        try await provider.unsubscribe(from: [.orderBookL2: symbol])
    }
}
