//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            textTimeView
            Spacer()
            Form {
                switch viewModel.state {
                case .initial:
                    EmptyView()
                case .loading:
                    VStack {
                        switch viewModel.loadingPhase {
                        case .serverConnecting:
                            VStack {
                                textConnectingView
                                ProgressView()
                            }
                        case .loadingGoods:
                            VStack {
                                textLoadingView
                                ProgressView()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .data(let items):
                    Section() {
                        List(items, id: \.id) { item in
                            HStack {
                                Image(systemName: item.imageName ?? "")
                                    .frame(width: 20, height: 20)
                                Spacer()
                                    .frame(width: 20)
                                Text(item.name)
                                    .frame(width: 140, alignment: .leading)
                                Text("\(String(item.price))$")
                            }
                        }
                        .padding(.vertical)
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            Spacer()
            Button("Старт") {
                viewModel.start()
            }
            .frame(height: 60)
            .padding()
        }
        .padding()
    }
    
    private var textTimeView: some View {
        Text("Оставшееся время: \(viewModel.timeValue)")
            .font(.title3)
            .padding(.bottom) 
    }
    
    private var textConnectingView: some View {
        Text("Подключение к серверу...")
            .font(.title2)
            .fontWeight(.semibold)
            .opacity(viewModel.opacityValue)
            .animation(.easeInOut(duration: 0.8), value: viewModel.opacityValue)
    }
    
    private var textLoadingView: some View {
        Text("Загрузка...")
            .font(.title2)
            .fontWeight(.semibold)
            .opacity(viewModel.opacityValue)
            .animation(.easeInOut(duration: 0.8), value: viewModel.opacityValue)
    }
}

#Preview {
    ContentView()
}
