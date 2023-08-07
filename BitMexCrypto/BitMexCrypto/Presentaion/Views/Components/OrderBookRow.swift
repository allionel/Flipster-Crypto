//
//  OrderBookRow.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct OrderBookRow: View {
    let data: OrderBookItem
    var body: some View {
        HStack {
            
        }
    }
    
    private func makeRtlRow() -> some View {
        HStack {
           
        }
        
    }
    
    private func makeLtrRow() -> some View {
        HStack {
            
        }
    }
    
    private func makePriceText() -> some View {
        Text(data.price.asString)
            .font(.appBody)
            .foregroundColor(.success)
    }
    
    private func qtyText()  -> some View {
        Text(data.qty.asString)
            .font(.appCaption)
            .foregroundColor(.appBlack)
    }
}

struct OrderBookRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookRow(data: OrderBookItem.mock)
    }
}
