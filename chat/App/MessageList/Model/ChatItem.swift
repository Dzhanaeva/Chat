//
//  ChatItem.swift
//  chat
//
//  Created by Гидаят Джанаева on 28.08.2024.
//

import Foundation
import FirebaseFirestore


struct ChatItem {
    var convoId: String?
    
    var name: String
    var otherUserId: String
    
    var date: Date
    var lastMessage: String?
    
    var hasUnreadMessages: Bool
    
    init(convoId: String?, name: String, otherUserId: String, date: Date, lastMessage: String?, hasUnreadMessages: Bool = false) {
        self.convoId = convoId
        self.name = name
        self.otherUserId = otherUserId
        self.date = date
        self.lastMessage = lastMessage
        self.hasUnreadMessages = hasUnreadMessages
    }
    
    init(convoId: String, data: [String: Any]) {
        self.convoId = convoId
        self.name = data["name"] as? String ?? ""
        self.otherUserId = data["otherId"] as? String ?? ""
        self.date = {
            let timeStamp = data["date"] as? Timestamp
            return timeStamp?.dateValue() ?? Date()
        }()
        
        self.lastMessage = data["lastMessage"] as? String ?? ""
        self.hasUnreadMessages = data["hasUnreadMessages"] as? Bool ?? false
    }
    

}
