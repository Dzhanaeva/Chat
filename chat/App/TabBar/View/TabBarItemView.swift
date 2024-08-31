//
//  TabBarItemView.swift
//  chat
//
//  Created by Гидаят Джанаева on 16.07.2024.
//

import UIKit

class TabBarItemView: UIView {
    
    var selectedItem: TabItem
    var tabItem: TabItem
    var imageRightConstraints: NSLayoutConstraint?
    
    var isActive: Bool {
        willSet {
            self.imageRightConstraints?.isActive = !newValue
            self.contentView.backgroundColor = newValue ? UIColor(named: "Three") : .clear
            self.tabImage.image = newValue ? UIImage(named: tabItem.selectedItem) : UIImage(named: tabItem.tabImg)
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    var isSelected: (TabBarItemView) -> Void
    

    //MARK: - Инициализация
    
    init(selectedItem: TabItem, tabItem: TabItem, imageRightConstraints: NSLayoutConstraint? = nil, isActive: Bool, isSelected: @escaping (TabBarItemView) -> Void) {
        self.tabItem = tabItem
        self.imageRightConstraints = imageRightConstraints
        self.isActive = isActive
        self.isSelected = isSelected
        self.selectedItem = selectedItem
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        setupConstraints()
    }
    
    @objc func tapToTab() {
        self.isSelected(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = isActive ? UIColor(named: "Three") : .clear
        $0.layer.cornerRadius = 23
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToTab)))
        $0.addSubview(tabImage)
        $0.addSubview(tabText)
        return $0
    }(UIView())
    
    lazy var tabImage: UIImageView = {
        $0.image = isActive ? UIImage(named: tabItem.selectedItem) : UIImage(named: tabItem.tabImg)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 28).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return $0
    }(UIImageView())
    
    lazy var tabText: UILabel = {
        $0.text = tabItem.tabText
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "Four")
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        return $0
    }(UILabel())
    
//MARK: - Constraints
    
    private func setupConstraints() {
        imageRightConstraints = tabImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        imageRightConstraints?.isActive = !isActive

        

        
         NSLayoutConstraint.activate([
             contentView.topAnchor.constraint(equalTo: topAnchor),
             contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
             contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
             contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
             
             tabImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
             tabImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
             tabImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
             tabImage.trailingAnchor.constraint(equalTo: tabText.leadingAnchor, constant: -5),
             
             tabText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
             tabText.centerYAnchor.constraint(equalTo: tabImage.centerYAnchor)
         ])
        
        
     }
    
    
}

