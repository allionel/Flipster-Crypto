//
//  UseCaseDependencyContainer.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Foundation

final class UseCaseDependencyContainer {
    private let repositories: RepositoryDependencyContainer
    
    init(socketManager: WebSocketManager) {
        repositories = .init(socketManager: socketManager)
    }
    
    lazy var orderBook: OrderBookUseCase = {
        return OrderBookUseCaseImp(repository: repositories.orderBook)
    }()
}
