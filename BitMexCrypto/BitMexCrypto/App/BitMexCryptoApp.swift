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
            let data = OrderBook.Mock.buyList.data.map(\.toLocalModel)
            OrderBookList(totalSize: 12000, data: data)
        }
    }
}
