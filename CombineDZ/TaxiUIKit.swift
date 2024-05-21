//
//  TaxiUIKit.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 22.05.2024.
//

/// ЗАДАНИЕ TASK3 
import UIKit
import Combine

final class ViewController: UIViewController {
    ///Для отображения данных
       private let dataLabel = UILabel()
       ///Для отображения статуса
       private let statusLabel = UILabel()
       /// Для отмены заказа
       private var cancelButton = UIButton()
       /// Для вызова такси
       private var refreshButton = UIButton()
        /// Набор для хранения подписок Combine
       private var cancelLabel = Set<AnyCancellable>()
       /// ViewModel для управления данными и статусом
        var viewModel = TaxiViewModel()
       
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    //MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .white
        setupStatusLabel()
        setupDataLabel()
        setupCancelButton()
        setupRefreshButton()
    }
    
    private func setupBindings() {
        viewModel.$data
            .receive(on: RunLoop.main)
            .sink { [weak self] newData in
                self?.dataLabel.text = newData
            }
            .store(in: &cancelLabel)
        
        viewModel.$status
            .receive(on: RunLoop.main)
            .sink { [weak self] newStatus in
                self?.statusLabel.text = newStatus
            }
            .store(in: &cancelLabel)
    }
    
    private func setupStatusLabel() {
        statusLabel.frame = CGRect(x: 50, y: 450, width: 300, height: 50)
        statusLabel.text = viewModel.status
        statusLabel.font = .systemFont(ofSize: 20, weight: .bold)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 10
        statusLabel.layer.masksToBounds = true
        statusLabel.backgroundColor = UIColor(white: 0.95, alpha: 1)
        statusLabel.layer.shadowColor = UIColor.black.cgColor
        statusLabel.layer.shadowOpacity = 0.2
        statusLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        statusLabel.layer.shadowRadius = 4
        view.addSubview(statusLabel)
    }
    
    private func setupDataLabel() {
        dataLabel.frame = CGRect(x: 50, y: 510, width: 300, height: 50)
        dataLabel.text = viewModel.data
        dataLabel.textColor = .green
        dataLabel.textAlignment = .center
        dataLabel.font = .systemFont(ofSize: 20, weight: .bold)
        dataLabel.layer.cornerRadius = 10
        dataLabel.layer.masksToBounds = true
        dataLabel.backgroundColor = UIColor(white: 0.95, alpha: 1)
        dataLabel.layer.shadowColor = UIColor.black.cgColor
        dataLabel.layer.shadowOpacity = 0.2
        dataLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        dataLabel.layer.shadowRadius = 4
        view.addSubview(dataLabel)
    }
    
    private func setupCancelButton() {
        cancelButton.frame = CGRect(x: 20, y: 600, width: view.frame.width / 2 - 30, height: 50)
        cancelButton.setTitle("Отменить заказ", for: .normal)
        cancelButton.backgroundColor = .red
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.shadowColor = UIColor.black.cgColor
        cancelButton.layer.shadowOpacity = 0.2
        cancelButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        cancelButton.layer.shadowRadius = 4
        cancelButton.addTarget(self, action: #selector(tabCancellButton), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    private func setupRefreshButton() {
        refreshButton.frame = CGRect(x: view.frame.width / 2 + 10, y: 600, width: view.frame.width / 2 - 30, height: 50)
        refreshButton.setTitle("Вызвать такси", for: .normal)
        refreshButton.backgroundColor = .blue
        refreshButton.layer.cornerRadius = 10
        refreshButton.layer.shadowColor = UIColor.black.cgColor
        refreshButton.layer.shadowOpacity = 0.2
        refreshButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        refreshButton.layer.shadowRadius = 4
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        view.addSubview(refreshButton)
    }
    // MARK: - IBAction
    @objc func tabCancellButton() {
        viewModel.cancel()
    }
    
    @objc func refresh() {
        viewModel.refresh()
    }
}
