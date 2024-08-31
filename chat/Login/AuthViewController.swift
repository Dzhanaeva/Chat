//
//  AuthViewController.swift
//  chat
//
//  Created by Гидаят Джанаева on 04.07.2024.
//

import UIKit

class AuthViewController: UIViewController {
    
    let service = Service.shared
    var checkField = ChekField.shared
    var tapGest: UITapGestureRecognizer?
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Two")

        tapGest = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        email.restorationIdentifier = "email"
        password.restorationIdentifier = "password"
        
        view.addGestureRecognizer(tapGest!)
        view.addSubviews(authLabel, email, password, forgotPassword, authButton, labelNoAcc, buttonSignUp)
        
        setupConstraits()
  
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    //MARK: - Label
    
    let authLabel: UILabel = {
        $0.text = .localize("titleLogIn")
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    let labelNoAcc: UILabel = {
        $0.text = .localize("dntHaveAcc")
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    //MARK: - Text Field
    lazy var email: UITextField = TextField(fieldPlaceholder: .localize("email"), isPassword: false)
    
    lazy var password: UITextField = TextField(fieldPlaceholder: .localize("pass"), isPassword: true)
    
    //MARK: Alert
    
    func alertAction(_ header: String?, _ message: String?) -> UIAlertController {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        return alert
    }
    
    //MARK: - btn
    lazy var forgotPassword: UIButton = Button(buttonText: .localize("forgoBtn"), buttonColor: .clear, titleColor: UIColor(named: "One")!, border: .zero, borderColor: .none) {
        print("забыль(")
    }
    
    lazy var authButton: UIButton = Button(buttonText: .localize("logInButton"), buttonColor: UIColor(named: "One")!, titleColor: .white, border: .zero, borderColor: .none)  { [self] in
        
        if checkField.validField(email),
           checkField.validField(password) {
            service.authApp(userInfo: UserInfo(name: "", email: email.text!, password: password.text!)) { [weak self] responce  in
                
                    switch responce {
                        
                    case .success:
                        print("next")
                        self?.service.checkAuthState()
                        if self!.service.isLogin() {
                            self?.navigationController?.pushViewController(TabBarController(), animated: true)
                            print("вход")
                        } else {
                            print("Ошибка! Пользователь не залогинился после успешной авторизации")
                        }
                        
                    case .noVerifity:
                        let alert = self?.alertAction(.localize("oops"), .localize("alertNotVerified"))
                        let okBtn = UIAlertAction(title: "Ок", style: .cancel)
                        alert?.addAction(okBtn)
                        self?.present(alert!, animated: true)
                        
                    case .error:
                        let alert = self?.alertAction(.localize("oops"), .localize("alertIncorrect"))
                        let okBtn = UIAlertAction(title: "Ок", style: .cancel)
                        alert?.addAction(okBtn)
                        self?.present(alert!, animated: true)
                    }
                }
        }

    }
    
    lazy var buttonSignUp: UIButton = Button(buttonText: .localize("signUpButton"), buttonColor: .clear, titleColor: UIColor(named: "One")!, border: .zero, borderColor: .none) {
        self.navigationController?.pushViewController(RegViewController(), animated: true)
    }
    

    //MARK: - Constraints
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            authLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            authLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
        
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            email.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 45),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            email.heightAnchor.constraint(equalToConstant: 60),
            
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20),
            password.heightAnchor.constraint(equalToConstant: 60),
            
            forgotPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            forgotPassword.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 12),
            
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            authButton.heightAnchor.constraint(equalToConstant: 60),
            authButton.topAnchor.constraint(equalTo: forgotPassword.bottomAnchor, constant: 20),
            
            labelNoAcc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            labelNoAcc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            
            buttonSignUp.centerYAnchor.constraint(equalTo: labelNoAcc.centerYAnchor),
            buttonSignUp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
        ])
    }
}
