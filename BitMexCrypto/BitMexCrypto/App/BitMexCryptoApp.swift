//
//  BitMexCryptoApp.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import SwiftUI

@main
struct BitMexCryptoApp: App {
    var body: some Scene {
        WindowGroup {
            let data: OrderBookListData = .init(
                buyList: .buy(
                    total: 12000,
                    data: OrderBook.Mock.buyList.data.map(\.toLocalModel)),
                sellList: .sell(
                    total: 12000,
                    data: OrderBook.Mock.sellList.data.map(\.toLocalModel)))
            OrderBookListView(data: data)
        }
    }
}
