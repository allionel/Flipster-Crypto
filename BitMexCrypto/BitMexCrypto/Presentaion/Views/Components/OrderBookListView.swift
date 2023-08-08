//
//  OrderBookScrollListView.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookListView: View {
    let data: OrderBookListData
    
    var body: some View {
        VStack(spacing: .zero) {
            makeHedear()
            Divider()
            ScrollView {
                HStack(alignment: .top, spacing: .zero) {
                    makeOrderBookList(totalSize: data.buyList.totalSize, list: data.buyList)
                        .padding(.leading, .horizontalPadding)
                    makeOrderBookList(totalSize: data.sellList.totalSize, list: data.sellList)
                        .padding(.trailing, .horizontalPadding)
                }
            }
        }
    }
    
    private func makeHedear() -> some View {
        HStack {
            Text(String.orderBookSizeTitle.localized)
                .font(.appRegular)
                .foregroundColor(.surface)
            Spacer()
            Text(String.orderBookPriceTitle.localized)
                .font(.appRegular)
                .foregroundColor(.surface)
            Spacer()
            Text(String.orderBookSizeTitle.localized)
                .font(.appRegular)
                .foregroundColor(.surface)
        }
        .padding(.horizontalPadding)
    }
    
    private func makeOrderBookList(totalSize: Int, list: OrderBookListType) -> some View {
        VStack(spacing: .zero) {
            ForEach(list.data, id: \.self) { item in
                OrderBookRow(totalSize: totalSize, data: item)
                    .frame(height: OrderBookRow.height)
            }
        }
    }
}

struct OrderBookListView_Previews: PreviewProvider {
    static var previews: some View {
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

