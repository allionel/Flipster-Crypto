//
//  OrderBookView.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookView: View {
    @StateObject private var viewModel: OrderBookViewModel = .init()
    
    var body: some View {
        OrderBookListView(data: $viewModel.data)
            .showLoading(with: $viewModel.loading)
            .task {
                await viewModel.subscribeToOrderBooks()
            }
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView()
    }
}
