//
//  ValidationTask.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 21.05.2024.
//

import UIKit
import Combine

class FirstPipelineViewController: UIViewController {
    
    var viewModel = SecondPipelineViewModel()
    
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    
    let surnameLabel = UILabel()
    let surnameTextField = UITextField()
    
    var nameCancellable: AnyCancellable?
    var surnameCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
        nameCancellable = viewModel.$nameValidation
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: nameLabel)
        
        surnameCancellable = viewModel.$surnameValidation
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: surnameLabel)
    }
    
    private func setupUI() {
        nameLabel.frame = CGRect(x: 250, y: 100, width: 100, height: 50)
        nameTextField.frame = CGRect(x: 250, y: 150, width: 100, height: 50)
        nameTextField.placeholder = "Ваше имя"
        
        surnameLabel.frame = CGRect(x: 250, y: 200, width: 100, height: 50)
        surnameTextField.frame = CGRect(x: 250, y: 250, width: 100, height: 50)
        surnameTextField.placeholder = "Ваша фамилия"
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(surnameLabel)
        view.addSubview(surnameTextField)
    }
}

extension FirstPipelineViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            viewModel.name = string
        } else if textField == surnameTextField {
            viewModel.surname = string
        }
        
        return true
    }
}

class SecondPipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var surname = ""
    @Published var nameValidation: String? = ""
    @Published var surnameValidation: String? = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        /// Валидация имени
        $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: \.nameValidation, on: self)
            .store(in: &cancellables)
        
        /// Валидация фамилии
        $surname
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: \.surnameValidation, on: self)
            .store(in: &cancellables)
    }
}
