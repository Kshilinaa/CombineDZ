//
//  ValidationTask.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 21.05.2024.
//
import UIKit
import Combine

class FirstPipelineViewController: UIViewController {
    //MARK: - Constants
    var viewModel = SecondPipelineViewModel()
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let surnameLabel = UILabel()
    let surnameTextField = UITextField()
    var nameCancellable: AnyCancellable?
    var surnameCancellable: AnyCancellable?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
    //MARK: - Private Methods
    private func setupUI() {
        nameLabel.frame = CGRect(x: 20, y: 100, width: 100, height: 50)
        nameTextField.frame = CGRect(x: 95, y: 100, width: 250, height: 50)
        nameTextField.placeholder = "Ваше имя"
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        
        surnameLabel.frame = CGRect(x: 20, y: 200, width: 100, height: 50)
        surnameTextField.frame = CGRect(x: 95, y: 200, width: 250, height: 50)
        surnameTextField.placeholder = "Ваша фамилия"
        surnameTextField.layer.borderWidth = 1.0
        surnameTextField.layer.borderColor = UIColor.gray.cgColor
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(surnameLabel)
        view.addSubview(surnameTextField)
    }
}
//MARK: - Extension + UITextFieldDelegate
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
    //MARK: - Published
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
