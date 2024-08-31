//
//  RegViewController.swift
//  chat
//
//  Created by Гидаят Джанаева on 04.07.2024.
//

import UIKit

class RegViewController: UIViewController {
    
    var tapGest: UITapGestureRecognizer?
    var checkField = ChekField.shared
    var service = Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Two")
        
        nameField.restorationIdentifier = "name"
        emailField.restorationIdentifier = "email"
        passField.restorationIdentifier = "password"
        tapGest = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        
        view.addGestureRecognizer(tapGest!)
        view.addSubviews(labelSignUp, nameField, emailField, passField, confPass, signUpBtn, labelHaveAcc, logInBtn)
        
        setupConstraints()
        
    }
    
    //MARK: - Label
    let labelSignUp: UILabel = {
        $0.text = .localize("titleSignUp")
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 35, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    let labelHaveAcc: UILabel = {
        $0.text = .localize("labelHaveAcc")
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    //MARK: - убрать клавиатуру
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    

    //MARK: - Text Field
    
    lazy var nameField: UITextField = TextField(fieldPlaceholder: .localize("nameText"), isPassword: false)
    
    lazy var emailField: UITextField = TextField(fieldPlaceholder: .localize("email"), isPassword: false)
    
    lazy var passField: UITextField = TextField(fieldPlaceholder: .localize("pass") , isPassword: true)
    
    lazy var confPass: UITextField = TextField(fieldPlaceholder: .localize("confirmPass"), isPassword: true)
    
    //MARK: - Регистрация
    
    lazy var signUpBtn: UIButton = Button(buttonText: .localize("signUpButton"), buttonColor: UIColor(named: "One")!, titleColor: .white, border: .zero, borderColor: .none) { [self] in
        
        if checkField.validField(nameField),
           checkField.validField(emailField),
           checkField.validField(passField) {
            if passField.text == confPass.text {
                
                service.createNewUser(UserInfo(name: nameField.text!, email: emailField.text!, password: passField.text!)) { [weak self] code in
                    
                    switch code.code {
                        
                    case 0:
                        print("Ошибка регистрации")
                        
                    case 1:
                        print("Регистрация прошла успешно")
                        self?.service.confirmEmail()
                        
                        let alert = UIAlertController(title: .localize("hooray"), message: .localize("alertConfirmEmail"), preferredStyle: .alert)
                        
                        let okBtn = UIAlertAction(title: .localize("hooray"), style: .default) { _ in
                            self?.navigationController?.pushViewController(AuthViewController(), animated: true)
                        }
                        
                        alert.addAction(okBtn)
                        
                        self?.present(alert, animated: true)
                    default:
                        print("Неизвестная ошибка")
                    }
                }
            } else {
                print("Пароли не совпадают")
            }
        }
    }
    
    //MARK: - Переход на страницу авторизации
    
    lazy var logInBtn: UIButton = Button(buttonText: .localize("logInButton"), buttonColor: .clear, titleColor: UIColor(named: "One")!, border: .zero, borderColor: .none) {
        self.navigationController?.pushViewController(AuthViewController(), animated: true)
    }
    

    //MARK: - Contraints
    func setupConstraints() {
        NSLayoutConstraint.activate([

            labelSignUp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            labelSignUp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 95),
            
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameField.topAnchor.constraint(equalTo: labelSignUp.bottomAnchor, constant: 45),
            nameField.heightAnchor.constraint(equalToConstant: 60),
            
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            emailField.heightAnchor.constraint(equalToConstant: 60),
            
            passField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passField.heightAnchor.constraint(equalToConstant: 60),
            
            confPass.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confPass.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confPass.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 20),
            confPass.heightAnchor.constraint(equalToConstant: 60),
            
            signUpBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signUpBtn.topAnchor.constraint(equalTo: confPass.bottomAnchor, constant: 20),
            signUpBtn.heightAnchor.constraint(equalToConstant: 60),
            
            labelHaveAcc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 43),
            labelHaveAcc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            
            logInBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -43),
            logInBtn.centerYAnchor.constraint(equalTo: labelHaveAcc.centerYAnchor)
        ])
    }
}
