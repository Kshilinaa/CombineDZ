//
//  ContentViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 27.05.2024.
//

import Foundation
import Combine

enum ViewState<Model> {
    case initial
    case loading
    case data(_ data: Model)
    case error(_ error: Error)
}

enum LoadingState {
    case serverConnecting
    case loadingGoods
}

struct Item: Identifiable {
    var id = UUID()
    var imageName: String?
    var name: String
    var price: Int
}

class ContentViewModel: ObservableObject {
    @Published var state: ViewState<[Item]> = .initial
    @Published var loadingPhase: LoadingState = .serverConnecting
    @Published var opacityValue: Double = 1.0
    @Published var timeValue = ""
    
    private var elapsedSeconds = 0

    let verifyState = PassthroughSubject<String, Never>()

    var cancellables: Set<AnyCancellable> = []
    var timer: AnyCancellable?
    var animationTimer: AnyCancellable?

    
    var fetchedItems: [Item] = [
        .init(imageName: "iphone", name: "iPhone 14", price: 999),
        .init(imageName: "leaf.fill", name: "Garden Shovel", price: 35),
        .init(imageName: "paintbrush.fill", name: "Art Set", price: 50),
        .init(imageName: "stethoscope", name: "Medical Kit", price: 120),
        .init(imageName: "bicycle", name: "Mountain Bike", price: 800),
        .init(imageName: "airplane", name: "Model Airplane", price: 75),
        .init(imageName: "laptopcomputer", name: "Laptop", price: 1200),
        .init(imageName: "headphones", name: "Wireless Headphones", price: 250),
        .init(imageName: "bed.double.fill", name: "Luxury Bedding", price: 200),
        .init(imageName: "flame.fill", name: "Camping Stove", price: 60),
        .init(imageName: "car.fill", name: "Remote Control Car", price: 90),
        .init(imageName: "globe", name: "World Globe", price: 100),
        .init(imageName: "music.note", name: "Guitar", price: 500),
        .init(imageName: "camera.fill", name: "Digital Camera", price: 350),
        .init(imageName: "scooter", name: "Electric Scooter", price: 450),
        .init(imageName: "desktopcomputer", name: "Desktop Computer", price: 1500)
    ]
    
    init() {
        bind()
    }

    func start() {
        elapsedSeconds = 0
        startTimer()
        state = .loading
        loadingPhase = .serverConnecting
        simulateLoading()
        startAnimation()
    }

    func bind() {
        verifyState
            .sink(receiveValue: { [unowned self] value in
                if !value.isEmpty {
                    timeValue = value
                }
            })
            .store(in: &cancellables)
        
    }
    
    private func startAnimation() {
        animationTimer = Timer
                .publish(every: 0.8, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                        self.opacityValue = self.opacityValue == 1.0 ? 0.0 : 1.0
                }
        }
    
    func startTimer() {
            verifyState.send("00:00")
            timer = Timer
                .publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink(receiveValue: { [unowned self] date in
                    elapsedSeconds += 1
                    let minutes = elapsedSeconds / 60
                    let seconds = elapsedSeconds % 60
                    let timeString = String(format: "%02d:%02d", minutes, seconds)
                    verifyState.send(timeString)
                })
    }
    
    private func showItems() {
            _ = Just(fetchedItems)
                .map { items in
                    items.filter { $0.price >= 100 && $0.imageName != nil }
                }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.state = .error(error)
                    }
                }, receiveValue: { [unowned self] items in
                    self.timer?.cancel()
                    self.state = .data(items)
                })
        }

    
    private func simulateLoading() {
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              self.loadingPhase = .loadingGoods
              DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                  self.showItems()
              }
          }
      }
  
    
   
}
