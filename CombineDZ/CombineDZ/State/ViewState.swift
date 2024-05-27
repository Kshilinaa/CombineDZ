//
//  ViewState.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 27.05.2024.
//

import Foundation

/// Состояние,, которое может отображаться на экране
enum ViewState<Model> {
    /// Загрузка данных
    case loading
    /// Данные успешно загружены и готовы к отображению
    case data(_ data: Model)
    /// Возникла ошибка при загрузке данных
    case error(_ error: Error)
}
