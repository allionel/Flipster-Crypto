//
//  ContentView.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel: ViewModel = .init()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
//        .task {
//           await viewModel.subscribe()
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


@MainActor
final class ViewModel: ObservableObject {
    let useCase: OrderBookUseCase = DependencyContainer.shared.useCases.orderBook
    private var bag: Set<AnyCancellable> = .init()
    
    @Published var data: [OrderBookItem]? = []
    
    init() {
        useCase.messagePublisher
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .finished:
                    print("fin")
                case .failure(let error):
                    print(error)
                }
                debugPrint($0)
            } receiveValue: { book in
                print(book)
            }.store(in: &bag)
        subscribe()
    }
    func subscribe() {
        Task {
        do {
            try await useCase.subscribeToOrderBookL2(with: .xbtusd)
            
        } catch {
            print(error)
        }
            
        }
    }
}
