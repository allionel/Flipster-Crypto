//
//  RepositoryDependencyContainer.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Foundation

final class RepositoryDependencyContainer {
    private let socketManager: WebSocketManager
    
    init(socketManager: WebSocketManager) {
        self.socketManager = socketManager
    }
    
    lazy var orderBook: OrderBookRepositoryImp = {
        let provider = BitMexWebSocket<WebSocketManager, OrderBook>(webSocketStream: socketManager)
        let repository = OrderBookRepositoryImp<BitMexWebSocket, OrderBook>(provider: provider)
        return repository
    }()
}
