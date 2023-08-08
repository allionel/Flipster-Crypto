//
//  RepositoryDependencyContainer.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Foundation

final class RepositoryDependencyContainer {
    init() {}
    
    lazy var orderBook: OrderBookRepositoryImp = {
        let socketManager: WebSocketManager = .init(url: Configuration.shared.baseURL)
        let provider = BitMexWebSocket<WebSocketManager, OrderBook>(webSocketStream: socketManager)
        let repository = OrderBookRepositoryImp<BitMexWebSocket, OrderBook>(provider: provider)
        return repository
    }()
    
    lazy var recentTrade: RecentTradeRepositoryImp = {
        let socketManager: WebSocketManager = .init(url: Configuration.shared.baseURL)
        let provider = BitMexWebSocket<WebSocketManager, RecentTrade>(webSocketStream: socketManager)
        let repository = RecentTradeRepositoryImp<BitMexWebSocket, RecentTrade>(provider: provider)
        return repository
    }()
}
