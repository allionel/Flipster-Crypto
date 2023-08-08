//
//  Font+Constants.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import struct SwiftUI.Font

public extension Font {
    static var appTitle: Font {
        .system(Font.TextStyle.title, design: .default, weight: .bold)
    }
    
    static var appBody: Font {
        .system(Font.TextStyle.callout, design: .default, weight: .bold)
    }
    
    static var appCaption: Font {
        .system(Font.TextStyle.callout, design: .default, weight: .regular)
    }
    
    static var appRegular: Font {
        .system(Font.TextStyle.callout, design: .default, weight: .regular)
    }
}
