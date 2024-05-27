//
//  ErrorAlert.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 27.05.2024.
//

import Foundation

struct AlertError: Error, Identifiable {
    /// Уникальный идентификатор ошибки
    var id = UUID()
    /// Заголовок ошибки (по умолчанию "Error")
    let title = "Error"
    /// Сообщение об ошибке
    let message: String
}
