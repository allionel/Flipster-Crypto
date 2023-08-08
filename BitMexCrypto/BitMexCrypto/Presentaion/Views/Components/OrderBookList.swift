//
//  OrderBookList.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookList: View {
    let totalSize: Int
    let data: [OrderBookItem]
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: .zero) {
                    ForEach(data, id: \.self) { item in
                        OrderBookRow(totalSize: totalSize, data: item)
                            .frame(height: 32)
                    }
                }
            }
    }
}

struct OrderBookList_Previews: PreviewProvider {
    static var previews: some View {
        let data = OrderBook.Mock.list.data.map(\.toLocalModel)
        OrderBookList(totalSize: 12000, data: data)
    }
}
