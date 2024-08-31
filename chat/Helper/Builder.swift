//
//  Builder.swift
//  chat
//
//  Created by Гидаят Джанаева on 06.08.2024.
//

import UIKit

class Builder: UIViewController {
    
    static func getMessangerView(chatItem: ChatItem) -> UIViewController {
        let view = MessangerView()
        let presenter = MessangerPresenter(view: view, convoId: chatItem.convoId, otherId: chatItem.otherUserId, name: chatItem.name)
        view.presenter = presenter
        return view
        
        
    }
}
