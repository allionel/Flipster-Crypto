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
            RecentTradeList(data: .constant(RecentTrade.Mock.buyList.data.map(\.asLocalData)))
        }
    }
}
