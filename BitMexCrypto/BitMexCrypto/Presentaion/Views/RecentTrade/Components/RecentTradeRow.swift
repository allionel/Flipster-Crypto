//
//  RecentTradeRow.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct RecentTradeRow: View {
    let data: RecentTradeItem
    
    static let height: CGFloat = 36
    
    var body: some View {
        makeTradeRow()
            .easeOutAnimation(by: data)
    }
    
    private var side: TradeSide {
        data.tradeSide
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
            .foregroundColor(side.isBuy ? .success : .alert)
    }
    
    private func makeQtyText() -> some View {
        Text(data.qty.asFormattedAmount)
            .font(.appCaption)
            .foregroundColor(.appBlack)
    }
    
    private func makeTimeText() -> some View {
        Text(data.timestamp.asShortTime)
            .font(.appCaption)
            .foregroundColor(.appBlack)
    }
}

struct RecentTradeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecentTradeRow(data: RecentTradeItem.mock)
    }
}


extension Date {
    var asShortTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let time = formatter.string(from: Date.now)
        return time
    }
}
