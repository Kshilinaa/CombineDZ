//
//  TaskUIKit.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 23.05.2024.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    var viewModel = ViewModelTextField()

    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.delegate = self
        return textField
    }()
    
    lazy var cleanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить список", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(cleanButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.systemGray6
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        tableView.dataSource = self
    }

    func setupUI() {
        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(cleanButton)
        view.addSubview(tableView)
        view.backgroundColor = UIColor.white
    }

    func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        cleanButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            addButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            
            cleanButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            cleanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cleanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cleanButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: cleanButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addButtonTapped()
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.items[indexPath.row]
        return cell
    }
    
    @objc func addButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        viewModel.addItem(text)
        tableView.reloadData()
        textField.text = ""
    }

    @objc func cleanButtonTapped() {
        viewModel.clearList()
        tableView.reloadData()
    }
}

#Preview {
    ViewController()
}
