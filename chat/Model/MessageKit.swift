//
//  MessageKit.swift
//  chat
//
//  Created by Гидаят Джанаева on 28.08.2024.
//

import Foundation
import MessageKit
import FirebaseFirestore

struct Sender: SenderType {
    var senderId: String
    var displayName: String

}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: SenderType, messageId: String, sentDate: Date, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
    }
    
    init(messageId: String, data: [String: Any]) {
        self.messageId = messageId
        self.sender = Sender(senderId: data["senderId"] as? String ?? "", displayName: Service.shared.getUserName())
        self.kind = .text(data["message"] as? String ?? "")
        self.sentDate = {
            let timestamp = data["date"] as? Timestamp
            return timestamp?.dateValue() ?? Date()
        }()
    }
}
