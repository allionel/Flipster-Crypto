//
//  OrderBookRepository.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Combine

protocol OrderBookRepository {
    func subscribe(to topics: [SubscriptionTopic: String]) async -> RemoteResponse<OrderBook>?
    func unsubscribe(from topics: [SubscriptionTopic: String]) async throws
}

struct OrderBookRepositoryImp<Provider: WebSocketProvider> {
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
}

extension OrderBookRepositoryImp: OrderBookRepository {
    func subscribe(to topics: [SubscriptionTopic: String]) async -> RemoteResponse<OrderBook>? {
        await provider.subscribe(to: topics)
    }
    
    func unsubscribe(from topics: [SubscriptionTopic: String]) async throws {
        try await provider.unsubscribe(from: topics)
    }
}
