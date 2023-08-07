//
//  RecentTradeRepository.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Combine

public protocol RecentTradeRepository {
    associatedtype DataOutput
    func subscribeToTrade(with symbol: String) async throws
    func unsubscribeFromTrade(with symbol: String) async throws
    var messagePublisher: AnyPublisher<DataOutput, WebSocketError> { get }
}

public final class RecentTradeRepositoryImp<Provider: WebSocketProvider, DataOutput: Decodable>: CancellableBagHolder where Provider.DataOutput == DataOutput {
    private let provider: Provider
    private let messageSender: PassthroughSubject<DataOutput, WebSocketError> = .init()
    
    public var canellables: Set<AnyCancellable> = .init()
    public var messagePublisher: AnyPublisher<DataOutput, WebSocketError> {
        messageSender.eraseToAnyPublisher()
    }
    
    public init(provider: Provider) {
        self.provider = provider
    }
}

extension RecentTradeRepositoryImp: RecentTradeRepository {
    public func subscribeToTrade(with symbol: String) async throws  {
        provider.messagePublisher.sink { [weak self] in
            self?.messageSender.send(completion: .failure($0.error))
        } receiveValue: { [weak self] in
            self?.messageSender.send($0)
        }.store(in: &canellables)
        try await provider.subscribe(to: [.trade: symbol])
    }
    
    public func unsubscribeFromTrade(with symbol: String) async throws {
        try await provider.unsubscribe(from: [.trade: symbol])
    }
}
