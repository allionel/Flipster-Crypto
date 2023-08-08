//
//  Font+Constants.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import struct SwiftUI.Font

public extension Font {
    static var appTitle: Font {
        .system(Font.TextStyle.headline, design: .default, weight: .semibold)
    }
    
    static var appBody: Font {
        .system(Font.TextStyle.subheadline, design: .default, weight: .semibold)
    }
    
    static var appCaption: Font {
        .system(Font.TextStyle.footnote, design: .default, weight: .medium)
    }
    
    static var appRegular: Font {
        .system(Font.TextStyle.callout, design: .default, weight: .regular)
    }
}
