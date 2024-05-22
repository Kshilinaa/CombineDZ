//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//
/// КОД ИЗ ВИДЕО
import SwiftUI
import Combine

struct FirstPipelineView: View {
    // MARK: - State
    @StateObject var viewModel = FirstPipelineViewModel()
    @State var validation = ""
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data)
                .font(.title)
                .foregroundColor(.green)
            
            Text(viewModel.status)
                .foregroundColor(.blue)
            
            Spacer()
            
            Button {
                viewModel.cancel()
            } label: {
                Text("Отменя подписки")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.red)
            .cornerRadius(8)
            .opacity(viewModel.status == "Запрос в банк..." ? 1.0 : 0.0)
            
            Button {
                viewModel.refresh()
            } label: {
                Text("Запрос данных")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.blue)
            .cornerRadius(8)
            .padding()
        }
    }
}

class FirstPipelineViewModel: ObservableObject {
    // MARK: - Published
    @Published var data = ""
    @Published var status = ""
    //MARK: - Types
    private var cancellable: AnyCancellable?
    
    // MARK: - Life Cycle
    init() {
        cancellable = $data
            .map { [unowned self] value -> String in
                status = "Запрос в банк..."
                return value
            }
            .debounce(for: 5, scheduler: DispatchQueue.main)
            .sink { [unowned self] value in
                self.data = "Сумма всех счетов 1 млн"
                self.status = "Данные получены"
            }
    }
    // MARK: - Public Methods
    func refresh() {
        data = "Перезапрос данных"
    }
    
    func cancel() {
        status = "Операция отменена"
        cancellable?.cancel()
        cancellable = nil
    }
}

#Preview {
    FirstPipelineView()
}
