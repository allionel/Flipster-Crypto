//
//  OrderBookScrollListView.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookListView: View {
    @Binding var data: OrderBookListData?
    
    var body: some View {
        GeometryReader { metrics in
            VStack(spacing: .zero) {
                makeHedear()
                Divider()
                ScrollView {
                    HStack(alignment: .top, spacing: .zero) {
                        Group {
                            makeOrderBookList(totalSize: data?.buyList.totalSize ?? .zero, data: data?.buyList.data ?? [])
                                .padding(.leading, .horizontalPadding)
                            makeOrderBookList(totalSize: data?.sellList.totalSize ?? .zero, data: data?.sellList.data ?? [])
                                .padding(.trailing, .horizontalPadding)
                        }
                        .frame(width: (metrics.size.width)/2)
                    }
                    .easeOutAnimation(by: data)
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
        .padding(.horizontal, .horizontalPadding)
        .padding(.vertical, .interItemSpacing)
    }
    
    private func makeOrderBookList(totalSize: Int, data: [OrderBookItem]) -> some View {
        VStack(spacing: .zero) {
            ForEach(data, id: \.self) { item in
                OrderBookRow(totalSize: totalSize, data: .constant(item))
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
                data: OrderBook.Mock.buyList.data.map(\.asLocalData)),
            sellList: .sell(
                total: 12000,
                data: OrderBook.Mock.sellList.data.map(\.asLocalData)))
        OrderBookListView(data: .constant(data))
    }
}

