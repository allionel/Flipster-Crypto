//
//  RecentTradeList.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct RecentTradeList: View {
    @Binding var data: [RecentTradeItem]
    
    var body: some View {
        VStack(spacing: .zero) {
            makeHedear()
            Divider()
            ScrollView {
                HStack(alignment: .top, spacing: .zero) {
                    VStack(spacing: .zero) {
                        ForEach(data, id: \.self) { item in
                            RecentTradeRow(data: .constant(item))
                                .frame(height: RecentTradeRow.height)
                        }
                    }
                }
                .easeOutAnimation(by: data)
            }
        }
    }
    
    private func makeHedear() -> some View {
        HStack {
            Text(String.orderBookPriceTitle.localized)
                .font(.appRegular)
                .foregroundColor(.surface)
            Spacer()
            Text(String.orderBookSizeTitle.localized)
                .font(.appRegular)
                .foregroundColor(.surface)
            Spacer()
            Text(String.timeTitle.localized)
                .font(.appRegular)
                .foregroundColor(.surface)
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.vertical, .interItemSpacing)
    }
}

struct RecentTradeList_Previews: PreviewProvider {
    static var previews: some View {
        RecentTradeList(data: .constant(RecentTrade.Mock.listOfAll.data.map(\.asLocalData)))
    }
}
