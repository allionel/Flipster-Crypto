//
//  LodingViewModifier.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import SwiftUI

public enum LoadingState {
    case ready
    case onGoing
    case finished
    
    var isLoading: Bool {
        self == .onGoing
    }
    
    var isFinished: Bool {
        self == .finished
    }
}

public struct LodingViewModifier: ViewModifier {
    @Binding public var loading: LoadingState
    
    private var isLoading: Binding<Bool> {
        .constant(loading.isLoading)
    }
    
    public func body(content: Content) -> some View {
        content
            .visibility(!loading.isLoading)
            .overlay {
                ProgressView()
                    .tint(.blue)
                    .visibility(loading.isLoading)
            }
    }
}

extension View {
    public func showLoading(with state: Binding<LoadingState>) -> some View {
        modifier(LodingViewModifier(loading: state))
    }
}







