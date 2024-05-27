//
//  Episodes.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 27.05.2024.
//

import Foundation

/// Модель эпизода
struct Episode: Codable {
    /// Название эпизода
    let name: String
    /// Код эпизода
    let episode: String
    /// Ссылки на персонажей, встречающихся в этом эпизоде
    let characters: [String]
}
/// Модель коллекции эпизодов
struct Episodes: Codable {
    /// Массив результатов, содержащий эпизоды/
    let results: [Episode]
}
/// Модель персонажа
struct Character: Codable {
    /// Имя персонажа
    let name: String
    /// Ссылка на изображение персонажа
    let image: String
}
