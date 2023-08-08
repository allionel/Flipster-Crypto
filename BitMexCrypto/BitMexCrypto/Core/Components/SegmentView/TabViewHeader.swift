//
//  TabViewHeader.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct TabViewHeader: View {
    var tabs: [String]
    @Binding var selectedTab: Int
    
    var body: some View {
        GeometryReader { metrics in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: .zero) {
                        ForEach(.zero ..< tabs.count, id: \.self) { index in
                            maketabButton(by: index, totalSize: metrics.size)
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }.frame(height: 64)
        }
    }
    
    @ViewBuilder
    private func maketabButton(by index: Int, totalSize: CGSize) -> some View {
        let indicatorWidth: CGFloat = totalSize.width / CGFloat(tabs.count)
        let textColor: Color = selectedTab == index ? .appBlack : .action
        let indicatorColor: Color = selectedTab == index ? .indicator : .clear
        
        Button {
            withAnimation {
                selectedTab = index
            }
        } label: {
            VStack(spacing: .zero) {
                HStack {
                    Text(tabs[index])
                        .font(.appTitle)
                        .foregroundColor(textColor)
                }.padding(.vertical, .interItemSpacing)
                
                Rectangle()
                    .fill(indicatorColor)
                    .frame(width: indicatorWidth, height: 3)
            }
        }
        .buttonStyle(.plain)
    }
}


struct TabViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        TabViewHeader(tabs: ["Tab 1", "Tab 2"], selectedTab: .constant(.zero))
    }
}
