//
//  RecentTradeView.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct RecentTradeView: View {
    @ObservedObject var viewModel: RecentTradeViewModel
    
    var body: some View {
        RecentTradeList(data: $viewModel.data)
            .task {
                await viewModel.subscribeOnSocket()
            }
    }
}

struct RecentTradeView_Previews: PreviewProvider {
    static var previews: some View {
        RecentTradeView(viewModel: .init())
    }
}

