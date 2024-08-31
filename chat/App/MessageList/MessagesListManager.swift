//
//  MessagesListManager.swift
//  chat
//
//  Created by Гидаят Джанаева on 13.08.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class MessagesListManager {
    
    func getChatList(completion: @escaping ([ChatItem]) -> Void) {
        guard let uid = Service.shared.getUserId()?.uid else { return }
        
        Firestore.firestore()
            .collection(.users)
            .document(uid)
            .collection(.conversation)
            .order(by: "date", descending: true)
            .addSnapshotListener { snap, err in
                guard err  == nil else { return }
                
                guard let doc = snap?.documents else { return }
                var chatItems: [ChatItem] = []

                doc.forEach {
                    let chatItem = ChatItem(convoId: $0.documentID, data: $0.data())
                    chatItems.append(chatItem)
                }
                completion(chatItems)
            }
    }

}
