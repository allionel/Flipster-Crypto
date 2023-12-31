//
//  OrderBookRow.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookRow: View {
    let totalSize: Int
    @Binding var data: OrderBookItem
    
    static let height: CGFloat = 36
    
    var body: some View {
        GeometryReader { metrics in
            Group {
                if side.isBuy {
                    makeLtrRow()
                } else {
                    makeRtlRow()
                }
            }
            
            .frame(height: Self.height)
            .background(alignment: alignment) {
                makeHightlightBackground(with: metrics.size.width)
            }
            .easeOutAnimation(by: data)
            .background(splashColor)
            .onAppear {
                withAnimation {
                    data.didHighlight = false
                }
            }
            .springAnimation(by: data.didHighlight, duration: 0.2)
        }
    }
    
    private var side: TradeSide {
        data.tradeSide
    }
    
    private var tintColor: Color {
        side.isBuy ? .success : .alert
    }
    
    private var splashColor: Color {
        data.didHighlight ? tintColor.opacity(0.5) : .clear
    }
    
    private var hightlightColor: Color {
        side.isBuy ? .lightSuccess : .lightAlert
    }
    
    private var alignment: Alignment {
        side.isBuy ? .trailing : .leading
    }
    
    private var volumRatio: CGFloat {
        Double(data.qty) / Double(totalSize)
    }
    
    private func makeLtrRow() -> some View {
        HStack {
            makeQtyText()
            Spacer()
            makePriceText()
                .padding(.trailing, .interItemSpacing)
        }
    }
    
    private func makeRtlRow() -> some View {
        HStack {
            makePriceText()
                .padding(.leading, .interItemSpacing)
            Spacer()
            makeQtyText()
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
        OrderBookRow(totalSize: 12000, data: .constant(OrderBookItem.mock))
    }
}
