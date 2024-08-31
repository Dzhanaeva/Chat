//
//  TextField.swift
//  chat
//
//  Created by Гидаят Джанаева on 04.07.2024.
//

import UIKit

class TextField: UITextField {
    
    var fieldPlaceholder: String
    var isPassword: Bool
    
    init(fieldPlaceholder: String, isPassword: Bool ) {
        self.fieldPlaceholder = fieldPlaceholder
        self.isPassword = isPassword
        
       
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupTextField()
    }
    
    private func setupTextField() {
        placeholder = fieldPlaceholder
        isSecureTextEntry = isPassword
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 1))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        rightViewMode = .always
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "One")?.cgColor
        textColor = .black
        layer.cornerRadius = 30
        

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
