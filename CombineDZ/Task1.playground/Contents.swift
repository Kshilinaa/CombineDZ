import UIKit
import Combine

/// Расширение для имени
extension Notification.Name {
    static let event = Notification.Name("signal")
}
/// Описание объекта для передачи
struct People {
    let name: String
}
/// Лейбл для подписки
let nameLabel = UILabel()

/// Создание издателя
let namePublisher = NotificationCenter
    .Publisher(center: .default, name: .event)
    .map { ($0.object as? People)?.name }

/// Создание подписчика
let nameSubscriber = Subscribers.Assign(object: nameLabel, keyPath: \.text)
/// Подписываемся на издателя
namePublisher.subscribe(nameSubscriber)
/// Объект для передачи в лейбл
let people = People(name: "Jack")
/// Отправка сигнала с объектом people
NotificationCenter.default.post(name: .event, object: people)
/// Результат
print(String(describing: nameLabel.text))


//Написать свой паблишер и сабскрайбер ⭐️

struct MyPublisher: Publisher {
    /// Определяем тип вывода, который производит этот издатель
    typealias Output = Int
    /// Определяем тип ошибки, которую может произвести  издатель (Never означает, что он никогда не завершится с ошибкой)
    typealias Failure = Never
    /// Свойство для хранения чисел, которые будут публиковаться
    let numbers: [Int]
    
    init(numbers: [Int]) {
        self.numbers = numbers
    }
    /// Метод для получения подписчика
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Int == S.Input {
        /// Создание подписки и передача подписчику
        let subscription = MySubscription(subscriber: subscriber, numbers: numbers)
        subscriber.receive(subscription: subscription)
    }
    /// Вложенный класс для реализации подписки
    private class MySubscription<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure {
        /// Свойство для хранения подписчика
        private var subscriber: S?
        /// Свойство для хранения чисел
               private let numbers: [Int]
        /// Текущий индекс для отслеживания прогресса
               private var currentIndex = 0
               
               init(subscriber: S, numbers: [Int]) {
                   self.subscriber = subscriber
                   self.numbers = numbers
               }
        /// Метод для обработки запроса на получение данных
               func request(_ demand: Subscribers.Demand) {
                   /// Публикуем числа до тех пор, пока они не закончатся
                   while currentIndex < numbers.count {
                       _ = subscriber?.receive(numbers[currentIndex])
                       currentIndex += 1
                   }
                   /// Сообщаем подписчику о завершении публикации
                   subscriber?.receive(completion: .finished)
               }
        /// Метод для отмены подписки
               func cancel() {
                   subscriber = nil
               }
    }
}
/// Класс для реализации подписчика
class MySubscriber: Subscriber {
    /// Определяем тип входных данных
    typealias Input = Int
    /// Определяем тип ошибки
    typealias Failure = Never
    
    /// Метод для получения подписки
    func receive(subscription: Subscription) {
        print("Подписка началась")
        /// Запрашиваем все доступные данные
        subscription.request(.unlimited)
    }
    /// Метод для получения данных
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Получено значение: \(input)")
        /// Не запрашиваем дополнительные данные
        return .none
    }
    /// Метод для обработки завершения подписки
    func receive(completion: Subscribers.Completion<Never>) {
        print("Подписка завершена")
    }
}


/// Массив чисел для публикации
let numbers = [1, 2, 3, 4, 5]
/// Создаем экземпляр издателя
let publisher = MyPublisher(numbers: numbers)
/// Создаем экземпляр подписчика
let subscriber = MySubscriber()

/// Подписываем подписчика на издателя
publisher.subscribe(subscriber)

