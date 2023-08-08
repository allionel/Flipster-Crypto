//
//  View+Animation.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func easeOutAnimation<Value: Equatable>(by value: Value, duration: Double = .animationDuration) -> some View {
        animation(.easeOut(duration: duration), value: value)
    }
    
    @ViewBuilder
    func springAnimation<Value: Equatable>(by value: Value, duration: Double = .animationDuration) -> some View {
        animation(.spring(response: duration), value: value)
    }
}
