//
//  UseCaseDependencyContainer.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Foundation

final class UseCaseDependencyContainer {
    private let repositories: RepositoryDependencyContainer
    
    init(repositories: RepositoryDependencyContainer) {
        self.repositories = repositories
    }
    
    lazy var orderBook: OrderBookUseCase = {
        return OrderBookUseCaseImp(repository: repositories.orderBook)
    }()
    
    lazy var recentTrade: RecentTradeUseCase = {
        return RecentTradeUseCaseImp(repository: repositories.recentTrade)
    }()
}
