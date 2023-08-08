//
//  TabViewPage.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct TabViewPage: View {
    @StateObject var orderBookViewModel: OrderBookViewModel = .init()
    @StateObject private var recentTradeViewModel: RecentTradeViewModel = .init()
    
    var body: some View {
        SegmentViewPage(tabs: [
            .init(title: .orderBookTitle.localized, view: AnyView(OrderBookView(viewModel: orderBookViewModel))),
            .init(title: .recentTradeTitle.localized, view: .init(RecentTradeView(viewModel: recentTradeViewModel)))
        ])
//        .showLoading(with: .constant(orderBookViewModel.loading))
        
    }
}

struct TabViewPage_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPage()
    }
}
