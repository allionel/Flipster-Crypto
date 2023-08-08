//
//  RecentTradeViewModel.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation
import Combine

@MainActor
final class RecentTradeViewModel: ObservableObject {
    @Published var data: [RecentTradeItem] = []
    @Published var loading: LoadingState = .onGoing
    
    private let useCase: RecentTradeUseCase
    private var canellables: Set<AnyCancellable> = .init()
    
    private let maxCount: Int = 30
    
    init(useCase: RecentTradeUseCase = DependencyContainer.shared.useCases.recentTrade) {
        self.useCase = useCase
        bindData()
        
//        Task {
//
//            do {
//                try await useCase.subscribeToTrade(with: .xbtusd)
//            } catch {
//                Debugger.print(error)
//                unsubscribeMessaging()
//            }
//        }
    }
    
    func subscribeOnSocket() async {
//        Task {
            do {
                try await useCase.subscribeToTrade(with: .xbtusd)
            } catch {
                Debugger.print(error)
                unsubscribeMessaging()
            }
//        }
    }
    
    private func unsubscribeMessaging() {
        Task {
            try await self.useCase.unsubscribeFromTrade(with: .xbtusd)
        }
    }
    
    private func bindData() {
        useCase.messagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    Debugger.print("The Stream has been Finished")
                case .failure(let error):
                    Debugger.print(error.asWebSocketError)
                }
                unsubscribeMessaging()
            } receiveValue: { [weak self] recentTrade in
                guard let self else { return }
                processData(by: recentTrade)
            }.store(in: &canellables)
        
        $data.map {
            $0.isEmpty ? .onGoing : .finished
        }.assign(to: &$loading)
    }
    
    private func processData(by recentTrade: RecentTrade) {
//        switch recentTrade.action {
//        case .partial:
//            handlePartialData(with: orderBook.data)
//        case .delete:
//            delete(with: orderBook.data)
//        case .update:
//            update(with: orderBook.data)
//        case .insert:
//            insert(with: orderBook.data)
//        case .none:
//            break
//        }
    }
}
