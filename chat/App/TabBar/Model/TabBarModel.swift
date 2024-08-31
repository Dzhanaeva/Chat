//
//  TabBarModel.swift
//  chat
//
//  Created by Гидаят Джанаева on 16.07.2024.
//

import UIKit

class TabBarModel {
    
    func setupViewController() -> [UIViewController] {
        let usersVC = UserListViewController()
        let messVC = MessagesListViewController()
        let settingsVC = SettingsViewController()
        
        return [
        usersVC, messVC, settingsVC
        ]
    }
    
    func createTabItems() -> [TabItem] {
        [
            TabItem(index: 0, tabText: .localize("tabTextFriends"), tabImg: "person", selectedItem: "person.fill"),
            TabItem(index: 1, tabText: .localize("tabTextMessages"), tabImg: "message", selectedItem: "message.fill"),
            TabItem(index: 2, tabText: .localize("tabTextSettings"), tabImg: "settings", selectedItem: "settings.fill")
        ]
    }
}
