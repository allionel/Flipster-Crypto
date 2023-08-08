//
//  RecentTradeRow.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct RecentTradeRow: View {
    @Binding var data: RecentTradeItem
    
    static let height: CGFloat = 36
    
    var body: some View {
        makeTradeRow()
            .easeOutAnimation(by: data)
    }
    
    private var side: TradeSide {
        data.tradeSide
    }
    
    private var tintColor: Color {
        side.isBuy ? .success : .alert
    }
    
    private func makeTradeRow() -> some View {
        HStack {
            makePriceText()
                .padding(.leading, .interItemSpacing)
            Spacer()
            makeQtyText()
            Spacer()
            makeTimeText()
                .padding(.trailing, .interItemSpacing)
        }
    }

    private func makePriceText() -> some View {
        Text(data.price.asFormattedPrice)
            .font(.appBody)
            .foregroundColor(tintColor)
    }
    
    private func makeQtyText() -> some View {
        Text(data.qty.asFormattedAmount)
            .font(.appBody)
            .foregroundColor(tintColor)
    }
    
    private func makeTimeText() -> some View {
        Text(data.timestamp.asShortTime)
            .font(.appBody)
            .foregroundColor(tintColor)
    }
}

struct RecentTradeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecentTradeRow(data: .constant(RecentTradeItem.mock))
    }
}
