//
//  OrderBookViewModel.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation
import Combine

@MainActor
final class OrderBookViewModel: ObservableObject {
    @Published var data: OrderBookListData?
    @Published var loading: LoadingState = .onGoing
    
    private let useCase: OrderBookUseCase
    private var canellables: Set<AnyCancellable> = .init()
    
    private let maxCount: Int = 20
    
    init(useCase: OrderBookUseCase = DependencyContainer.shared.useCases.orderBook) {
        self.useCase = useCase
        bindData()

        Task {
            do {
                try await useCase.subscribeToOrderBookL2(with: .xbtusd)
            } catch {
                Debugger.print(error)
                unsubscribeMessaging()
            }
        }
    }
    
    private func unsubscribeMessaging() {
        Task {
            try await self.useCase.subscribeToOrderBookL2(with: .xbtusd)
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
            } receiveValue: { [weak self] orderBook in
                guard let self else { return }
                processData(by: orderBook)
            }.store(in: &canellables)
        
        $data.map {
            $0.isNil ? .onGoing : .finished
        }.assign(to: &$loading)
    }
    
    private func buyItems(with items: [OrderBook.OrderBookItem]) -> [OrderBookItem] {
        Array(items.filter(\.side.isBuy)
            .prefix(maxCount))
            .map(\.asLocalData)
    }
    
    private func sellItems(with items: [OrderBook.OrderBookItem]) -> [OrderBookItem] {
        Array(items.filter(\.side.isSell)
            .prefix(maxCount))
            .map(\.asLocalData)
    }
    
    private func processData(by orderBook: OrderBook) {
        switch orderBook.action {
        case .partial:
            handlePartialData(with: orderBook.data)
        case .delete:
            delete(with: orderBook.data)
        case .update:
            update(with: orderBook.data)
        case .insert:
            insert(with: orderBook.data)
        case .none:
            break
        }
    }
    
    private func handlePartialData(with items: [OrderBook.OrderBookItem]) {
        let buyItems = buyItems(with: items)
        let sellItems = sellItems(with: items)
        
        let buyItemsTotalSize = totalSize(of: buyItems)
        let sellItemsTotalSize = totalSize(of: sellItems)
        
        let sortedBuyItems = buyItems.sorted { $0.price > $1.price }
        let sortedSellItems = sellItems.sorted { $0.price < $1.price }
        
        data = .init(
            buyList: .buy(total: buyItemsTotalSize, data: sortedBuyItems),
            sellList: .sell(total: sellItemsTotalSize, data: sortedSellItems)
        )
    }
    
    private func insert(with items: [OrderBook.OrderBookItem]) {
        let buyItems = buyItems(with: items)
        let sellItems = sellItems(with: items)

        let newBuyItems = buyItems.map { item -> OrderBookItem in
            .init(id: item.id, qty: item.qty, price: item.price, tradeSide: item.tradeSide, didChange: true)
        }
        let newSellItems = sellItems.map { item -> OrderBookItem in
            .init(id: item.id, qty: item.qty, price: item.price, tradeSide: item.tradeSide, didChange: true)
        }
        
        var mutatingBuyItems = data?.buyList.data ?? []
        newBuyItems.forEach {
            mutatingBuyItems.append($0)
        }
        
        var mutatingSellItems = data?.sellList.data ?? []
        newSellItems.forEach {
            mutatingSellItems.append($0)
        }
        
        let buyItemsTotalSize = totalSize(of: mutatingBuyItems)
        let sellItemsTotalSize = totalSize(of: mutatingSellItems)
        
        let sortedBuyItems = mutatingBuyItems.sorted { $0.price > $1.price }
        let sortedSellItems = mutatingSellItems.sorted { $0.price < $1.price }
        
        data = .init(
            buyList: .buy(total: buyItemsTotalSize, data: limitedArray(sortedBuyItems)),
            sellList: .sell(total: sellItemsTotalSize, data: limitedArray(sortedSellItems))
        )
    }
    
    private func update(with items: [OrderBook.OrderBookItem]) {
        let buyItems = buyItems(with: items)
        let sellItems = sellItems(with: items)
        
        var mutatingBuyItems = data?.buyList.data ?? []
        buyItems.forEach { item in
            mutatingBuyItems.replace(.init(
                id: item.id,
                qty: item.qty,
                price: item.price,
                tradeSide: item.tradeSide,
                didChange: true)
            )
        }
        
        var mutatingSellItems = data?.sellList.data ?? []
        sellItems.forEach { item in
            mutatingSellItems.replace(.init(
                id: item.id,
                qty: item.qty,
                price: item.price,
                tradeSide: item.tradeSide,
                didChange: true)
            )
        }

        let buyItemsTotalSize = totalSize(of: mutatingBuyItems)
        let sellItemsTotalSize = totalSize(of: mutatingSellItems)
        
        let sortedBuyItems = mutatingBuyItems.sorted { $0.price > $1.price }
        let sortedSellItems = mutatingSellItems.sorted { $0.price < $1.price }
        
        data = .init(
            buyList: .buy(total: buyItemsTotalSize, data: limitedArray(sortedBuyItems)),
            sellList: .sell(total: sellItemsTotalSize, data: limitedArray(sortedSellItems))
        )
    }
    
    private func delete(with items: [OrderBook.OrderBookItem]) {
        let buyItems = buyItems(with: items)
        let sellItems = sellItems(with: items)
        
        var mutatingBuyItems = data?.buyList.data ?? []
        if !buyItems.isEmpty {
            buyItems.forEach { item in
                guard buyItems.count > 20 else { return }
                mutatingBuyItems.remove(item)
            }
        }
        
        var mutatingSellItems = data?.sellList.data ?? []
        if !sellItems.isEmpty {
            sellItems.forEach { item in
                guard sellItems.count > 20 else { return }
                mutatingSellItems.remove(item)
            }
        }

        let buyItemsTotalSize = totalSize(of: mutatingBuyItems)
        let sellItemsTotalSize = totalSize(of: mutatingSellItems)
        
        let sortedBuyItems = mutatingBuyItems.sorted { $0.price > $1.price }
        let sortedSellItems = mutatingSellItems.sorted { $0.price < $1.price }
        
        data = .init(
            buyList: .buy(total: buyItemsTotalSize, data: limitedArray(sortedBuyItems)),
            sellList: .sell(total: sellItemsTotalSize, data: limitedArray(sortedSellItems))
        )
    }
    
    private func limitedArray(_ list: [OrderBookItem]) -> [OrderBookItem] {
        Array(list.prefix(maxCount))
    }
    
    private func totalSize(of data: [OrderBookItem]) -> Int {
        data.reduce(.zero) { $0 + $1.qty }
    }
}
