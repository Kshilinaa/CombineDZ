//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//

import SwiftUI
import Combine

struct URLSessionDataTaskPublisherView: View {
    //MARK: - StateObject
    @StateObject var viewModel = URLSessionDataTaskPublisherViewModel()
    //MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            viewModel.avatarImage
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}
// MARK: - Public Properties
/// Структура для декодирования данных из JSON
struct Post: Decodable {
    ///Название
    let title: String
    /// Эпизод
    let body: String
}
/// Структуруа для  ошибки
struct ErrorForAlerrt: Error, Identifiable {
    /// Id
    var id = UUID()
    /// Наименование
    let title = "Error"
    /// Сообщение
    let message: String
}

#Preview {
    URLSessionDataTaskPublisherView()
}
