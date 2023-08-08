//
//  OrderBookRow.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookRow: View {
    let totalSize: Double
    let data: OrderBookItem
    
    var body: some View {
        GeometryReader { metrics in
            Group {
                if side.isBuy {
                    makeLtrRow()
                } else {
                    makeRtlRow()
                }
            }
            .padding(.minimumSpacing)
            .background(alignment: alignment, content: {
                makeHightlightBackground(with: metrics.size.width)
            })
        }
    }
    
    private var side: TradeSide {
        data.tradeSide
    }
    
    private var color: Color {
        side.isBuy ? .success : .alert
    }
    
    private var hightlightColor: Color {
        side.isBuy ? .lightSuccess : .lightAlert
    }
    
    private var alignment: Alignment {
        side.isBuy ? .trailing : .leading
    }
    
    private var volumRatio: CGFloat {
        data.qty / totalSize
    }
    
    private func makeLtrRow() -> some View {
        HStack {
            makeQtyText()
            Spacer()
            makePriceText()
        }
    }
    
    private func makeRtlRow() -> some View {
        HStack {
            makePriceText()
            Spacer()
            makeQtyText()
        }
    }

    private func makePriceText() -> some View {
        Text(data.price.asPrice)
            .font(.appBody)
            .foregroundColor(side.isBuy ? .success : .alert)
    }
    
    private func makeQtyText() -> some View {
        Text(data.qty.asString)
            .font(.appCaption)
            .foregroundColor(.appBlack)
    }
    
    @ViewBuilder
    private func makeHightlightBackground(with width: CGFloat) -> some View {
        let width: CGFloat = volumRatio * width
        Rectangle()
            .fill(hightlightColor)
            .frame(width: width)
    }
}

struct OrderBookRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookRow(totalSize: 120, data: OrderBookItem.mock)
    }
}
