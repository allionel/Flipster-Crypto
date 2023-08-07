//
//  RecentTradeUseCase.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Foundation
import Combine

public protocol RecentTradeUseCase {
    func subscribeToTrade(with symbol: SubscriptionSymbol) async throws
    func unsubscribeFromTrade(with symbol: SubscriptionSymbol) async throws
    var messagePublisher: AnyPublisher<RecentTrade, WebSocketError> { get }
}

public final class RecentTradeUseCaseImp<Repository: RecentTradeRepository>: CancellableBagHolder where Repository.DataOutput == RecentTrade {
    private let repository: Repository
    private let messageSender: PassthroughSubject<RecentTrade, WebSocketError> = .init()
    
    public var canellables: Set<AnyCancellable> = .init()
    public var messagePublisher: AnyPublisher<RecentTrade, WebSocketError> {
        messageSender.eraseToAnyPublisher()
    }
    public init(repository: Repository) {
        self.repository = repository
    }
}

extension RecentTradeUseCaseImp: RecentTradeUseCase {
    public func subscribeToTrade(with symbol: SubscriptionSymbol) async throws {
        repository.messagePublisher.sink { [weak self] in
            self?.messageSender.send(completion: .failure($0.error))
        } receiveValue: { [weak self] in
            self?.messageSender.send($0)
        }.store(in: &canellables)
        try await repository.subscribeToOrderBookL2(with: symbol.name)
    }
    
    public func unsubscribeFromTrade(with symbol: SubscriptionSymbol) async throws {
        try await repository.unsubscribeFromOrderBookL2(with: symbol.name)
    }
}
