//
//  TaskViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 27.05.2024.
//
import Combine
import SwiftUI

class TaskViewModel: ObservableObject {
       /// Состояние  для списка эпизодов
       @Published var state: ViewState<[Episode]> = .loading
       /// Массив изображений персонажей
       @Published var characterImages: [Image] = []
       /// Массив имен персонажей
       @Published var characterNames: [String] = []
       /// Ошибка для отображения предупреждения
       @Published var errorForAlert: AlertError?
    /// Набор для хранения подписок
    var cancellables: Set<AnyCancellable> = []
    // MARK: - Public Methods
    
    /// Функция для получения информации о персонаже
    func fetchCharacter(for episode: Episode) {
        let characterArrayMaxAmount = episode.characters.count
        let urlToRandomCharacter = episode.characters[Int.random(in: 0..<characterArrayMaxAmount)]
        guard let url = URL(string: urlToRandomCharacter) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Character.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] character in
                characterNames.append(character.name)
                let imageUrl = character.image
                fetchImage(url: imageUrl)
            }
            .store(in: &cancellables)
    }
    
    /// Функция для получения списка эпизодов
    func fetchEpisodes() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Episodes.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    errorForAlert = AlertError(message: error.localizedDescription)
                    state = .error(error)
                }
            } receiveValue: { [unowned self] episodes in
                let results = episodes.results.filter { !$0.episode.contains("S02") }
                for result in results {
                    fetchCharacter(for: result)
                }
                state = .data(results)
            }
            .store(in: &cancellables)
    }
   
    
    /// Функция для загрузки изображения по URL
    func fetchImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                guard let uiImage = UIImage(data: data) else {
                    throw AlertError(message: "No image")
                }
                return Image(uiImage: uiImage)
            }
            .receive(on: DispatchQueue.main)
            .replaceError(with: Image("blank"))
            .sink { [unowned self] image in
                characterImages.append(image)
            }
            .store(in: &cancellables)
    }
    
}
