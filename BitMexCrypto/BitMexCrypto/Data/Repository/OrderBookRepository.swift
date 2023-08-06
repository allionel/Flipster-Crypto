//
//  OrderBookRepository.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Combine
import SwiftUI

public protocol OrderBookRepository {
    associatedtype DataOutput
    func subscribeToOrderBookL2(with symbol: String) throws
    func unsubscribeFromOrderBookL2(with symbol: String) async throws
    var messagePublisher: AnyPublisher<DataOutput, Never> { get }
    
    
}

public final class OrderBookRepositoryImp<Provider: WebSocketProvider, DataOutput: Decodable>: ObservableObject where Provider.DataOutput == DataOutput {
    private let provider: Provider
    var bag: Set<AnyCancellable> = .init()
    public var messagePublisher: AnyPublisher<DataOutput, Never> {
        $msg.eraseToAnyPublisher()
    }
    @Published var msg: DataOutput = .empty
    public init(provider: Provider) {
        self.provider = provider
    }
}

extension OrderBookRepositoryImp: OrderBookRepository {
    public func subscribeToOrderBookL2(with symbol: String) throws {
       
            try provider.subscribe(to: [.orderBookL2: symbol])
            provider.messagePublisher.sink { res in
                
            } receiveValue: { data in
                self.msg = data
            }.store(in: &bag)
        
    }
    
    public func unsubscribeFromOrderBookL2(with symbol: String) async throws {
        try await provider.unsubscribe(from: [.orderBookL2: symbol])
    }
}
