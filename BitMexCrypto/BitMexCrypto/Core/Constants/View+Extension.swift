//
//  View+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func springAnimation<Value: Equatable>(by value: Value, duration: Double = .animationDuration) -> some View {
        animation(.spring(response: duration), value: value)
    }
}

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
