//
//  SegmentViewPage.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

struct SegmentViewPage: View {
    @State private var selectedTab: Int = .zero
    let tabs: [SegmentViewItem]
    
    var body: some View {
        VStack(spacing: .zero) {
            TabViewHeader(tabs: tabs.map(\.title), selectedTab: $selectedTab)
            TabView(selection: $selectedTab) {
                ForEach(tabs.enumeratedArray(), id: \.offset) { (index, tab) in
                    tab.view.tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct SegmentViewPage_Previews: PreviewProvider {
    static var previews: some View {
        SegmentViewPage(tabs: [
            .init(title: "tab 1", view: AnyView(RecentTradeView())),
            .init(title: "tab 2", view: AnyView(Text("tab 2")))
        ])
    }
}
