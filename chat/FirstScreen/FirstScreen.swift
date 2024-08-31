//
//  ViewController.swift
//  chat
//
//  Created by Гидаят Джанаева on 29.06.2024.
//

import UIKit

class FirstScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        view.addSubviews(imgFirstScreen, welcomeLabel, logInButton, signUpButton)
        setupConstraits()
    }

    
    let imgFirstScreen: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "imgFirstScreen")
        $0.heightAnchor.constraint(equalToConstant: 413).isActive = true
        return $0
    }(UIImageView())

    let welcomeLabel: UILabel = {
        $0.text = .localize("greeting")
        $0.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
        $0.numberOfLines = 2
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    
 //MARK: - Buttons
    
    private lazy var logInButton: UIButton = Button(buttonText: .localize("logInButton"), buttonColor: UIColor(named: "One")!, titleColor: .white, border: 0, borderColor: .none) {
        self.navigationController?.pushViewController(AuthViewController(), animated: true)
    
    }
    
    private lazy var signUpButton: UIButton = Button(buttonText: .localize("signUpButton"), buttonColor: .clear, titleColor: UIColor(named: "One")!, border: 2, borderColor: UIColor(named: "One")?.cgColor) {
        self.navigationController?.pushViewController(RegViewController(), animated: true)
    }
    
  //MARK: - Constraints
    
    func setupConstraits() {
        NSLayoutConstraint.activate([

            imgFirstScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imgFirstScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imgFirstScreen.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            welcomeLabel.topAnchor.constraint(equalTo: imgFirstScreen.bottomAnchor),
            
            logInButton.heightAnchor.constraint(equalToConstant: 60),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            logInButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 32),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  26),
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
            
        ])
    }
}

