//
//  OrderBookViewModel.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation
import Combine

final class OrderBookViewModel: ObservableObject, CancellableBagHolder {
    @Published var data: OrderBookListData?
    @Published var loading: LoadingState = .onGoing
    
    private let useCase: OrderBookUseCase
    var canellables: Set<AnyCancellable> = .init()
    
    private let maxCount: Int = 20
    
    init(useCase: OrderBookUseCase = DependencyContainer.shared.useCases.orderBook) {
        self.useCase = useCase
        bindData()
    }
    
    func subscribeToOrderBooks() async {
        do {
            try await useCase.subscribeToOrderBookL2(with: .xbtusd)
        } catch {
            Debugger.print(error)
        }
    }
    
    private func bindData() {
        useCase.messagePublisher
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    Debugger.print("The Stream has been Finished")
                case .failure(let error):
                    Debugger.print(error.asWebSocketError)
                }
            } receiveValue: { [weak self] orderBook in
                guard let self else { return }
                processData(by: orderBook.data)
            }.store(in: &canellables)
        
        $data.map {
            $0.isNil ? .onGoing : .finished
        }.assign(to: &$loading)
    }
    
    private func processData(by data: [OrderBook.OrderBookItem]) {
        let buyItems = Array(data.filter(\.side.isBuy).prefix(maxCount))
        let sellItems = Array(data.filter(\.side.isSell).prefix(maxCount))
        
        let buyItemsTotalSize = totalSize(of: buyItems)
        let sellItemsTotalSize = totalSize(of: sellItems)
        
        let sortedBuyItems = buyItems.sorted { $0.price > $1.price }.map(\.asLocalData)
        let sortedSellItems = sellItems.sorted { $0.price < $1.price }.map(\.asLocalData)
        
        self.data = .init(
            buyList: .buy(total: buyItemsTotalSize, data: sortedBuyItems),
            sellList: .sell(total: sellItemsTotalSize, data: sortedSellItems)
        )
    }
    
    private func totalSize(of data: [OrderBook.OrderBookItem]) -> Int {
        data.reduce(.zero) { $0 + ($1.size ?? .zero) }
    }
    
    
}

