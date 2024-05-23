//
//  ContentViewModel.swift
//  CombineDZ
//

import Combine
import SwiftUI

class ViewModelTextField: ObservableObject {
    @Published var inputText: String = ""
    @Published var items: [String] = []

    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = CurrentValueSubject<String, Never>("")

    init() {
        inputSubject
            .removeDuplicates()
            .sink { [weak self] text in
                self?.inputText = text
            }
            .store(in: &cancellables)

        $inputText
            .flatMap { text -> AnyPublisher<String, Never> in
                if text.isEmpty {
                    return Empty().eraseToAnyPublisher()
                } else {
                    return Just(text).delay(for: 1, scheduler: RunLoop.main).eraseToAnyPublisher()
                }
            }
            .map { [weak self] text in
                guard let self = self else { return }
                self.addItem(text)
            }
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)
    }

    func addItem(_ text: String) {
        guard !text.isEmpty else { return }
        items.append(text)
        inputText = ""
    }

    func clearList() {
        items.removeAll()
    }
}
