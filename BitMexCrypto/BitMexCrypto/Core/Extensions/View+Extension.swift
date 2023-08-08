//
//  View+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

extension View {
    func visible(_ isVisible: Bool) -> some View {
        opacity(isVisible ? 1 : 0)
    }

    @ViewBuilder
    func visibility(_ isVisible: Bool) -> some View {
        if isVisible { self }
        else { EmptyView() }
    }
}
