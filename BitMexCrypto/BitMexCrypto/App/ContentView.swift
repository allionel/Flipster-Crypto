//
//  ContentView.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import SwiftUI

struct ContentView: View {
    let stream: WebSocketStream = .init(url: "wss://ws.bitmex.com/realtime")
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
//            do {
//                for try await message in stream {
//                    Debugger.print(message)
//                }
//            } catch {
//                debugPrint("Oops something didn't go right")
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
