//
//  OrderBookView.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookView: View {
    @ObservedObject var viewModel: OrderBookViewModel 
    
    var body: some View {
        OrderBookListView(data: $viewModel.data)
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView(viewModel: .init())
    }
}
