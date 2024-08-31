//
//  Bottom.swift
//  chat
//
//  Created by Гидаят Джанаева on 03.07.2024.
//

import UIKit

class Button: UIButton {
    
    var buttonText: String
    var completion: () -> Void
    var buttonColor: UIColor
    var titleColor: UIColor
    var border: Int
    var borderColor: CGColor?


    init(buttonText: String, buttonColor: UIColor, titleColor: UIColor, border: Int, borderColor: CGColor?, completion: @escaping () -> Void) {
        self.buttonText = buttonText
        self.completion = completion
        self.buttonColor = buttonColor
        self.titleColor = titleColor
        self.border = border
        self.borderColor = borderColor

        
        super.init(frame: .zero)
        setupButton()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     private func setupButton() {
         addAction(UIAction(handler: { [weak self] _ in
             guard let self = self else {return}
             
             completion()
         }), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
         setTitle(buttonText, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        backgroundColor = buttonColor
        setTitleColor(titleColor, for: .normal)
        layer.borderWidth = CGFloat(border)
        layer.borderColor = borderColor
        layer.cornerRadius = 30
        layer.masksToBounds = true
         
//        showsTouchWhenHighlighted = true
//        adjustsImageWhenHighlighted = true
         
         if #available(iOS 15.0, *) {
             var config = UIButton.Configuration.filled()
             config.background.backgroundColor = buttonColor
             config.background.backgroundColorTransformer = UIConfigurationColorTransformer { incoming in
                 return incoming.withAlphaComponent(0.9)
             }
             config.baseForegroundColor = titleColor
             config.cornerStyle = .large
             config.buttonSize = .large
             
             self.configuration = config
         }
    }
}


 

