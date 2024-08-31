//
//  TabBarController.swift
//  chat
//
//  Created by Гидаят Джанаева on 16.07.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var tabBarModel = TabBarModel()

    override func viewDidLoad() {
     super.viewDidLoad()
        
     tabBar.isHidden = true
     navigationItem.hidesBackButton = true
     setViewControllers(tabBarModel.setupViewController(), animated: true)
           
     view.addSubviews(tabView)
     setupTabBar(pages: tabBarModel.createTabItems())
     setupConstraints()
}
    
    
    lazy var tabView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 35
        $0.addSubview(tabStack)
        return $0
    }(UIView())
    
    lazy var tabStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    
    private func setupTabBar(pages: [TabItem]) {
        pages.enumerated().forEach{ item in
            if item.offset == 0 {
                tabStack.addArrangedSubview(createOneTabBar(item: item.element, isFirst: true))
            } else {
                tabStack.addArrangedSubview(createOneTabBar(item: item.element))
            }
        }
    }
    
    private func createOneTabBar(item: TabItem, isFirst: Bool = false) -> UIView {
        TabBarItemView(selectedItem: item, tabItem: item, isActive: isFirst) { [weak self] selectItem in
            guard let self = self else {return}
            self.tabStack.arrangedSubviews.forEach {
                guard let tabItem = $0 as? TabBarItemView else {return}
                tabItem.isActive = false
            }
            selectItem.isActive.toggle()
            self.selectedIndex = item.index
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tabView.heightAnchor.constraint(equalToConstant: 70),
            
            tabStack.topAnchor.constraint(equalTo: tabView.topAnchor),
            tabStack.bottomAnchor.constraint(equalTo: tabView.bottomAnchor),
            tabStack.leadingAnchor.constraint(equalTo: tabView.leadingAnchor, constant: 20),
            tabStack.trailingAnchor.constraint(equalTo: tabView.trailingAnchor, constant: -20)
        ])
    }
}
