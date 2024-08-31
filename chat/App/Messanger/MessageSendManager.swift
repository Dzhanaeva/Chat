//
//  MessageSendManager.swift
//  chat
//
//  Created by Гидаят Джанаева on 11.08.2024.
//

import UIKit
import Firebase
import FirebaseFirestore

class MessageSendManager {
    func sendMessage(convoId: String?, message: String, otherUser: Sender, completion: @escaping (String?) -> Void) {
        guard let selfId = Service.shared.getUserId()?.uid else { return }

        if let convoId = convoId {
            setMessage(uid: selfId, convoId: convoId, message: message, otherUser: otherUser) { success in

                completion(success ? convoId : nil)
            }
        } else {
            createNewConvo(uid: selfId, message: message, otherUser: otherUser) { convoId in

                completion(convoId)
            }
        }
    }
    
//MARK: - Новый чат
    private func createNewConvo(uid: String, message: String, otherUser: Sender, completion: @escaping (String?) -> Void) {
        let convoId = UUID().uuidString
        
        let convoData: [String: Any] = [
            "date": Timestamp(date: Date()),
            "senderId": uid,
            "otherId": otherUser.senderId,
            "users": [uid, otherUser.senderId]
            
        ]
        print("Новый чат. uid: \(uid), otherUserId: \(otherUser.senderId)")
        
        Firestore.firestore()
            .collection(.conversation)
            .document(convoId)
            .setData(convoData) { error in
                if let error = error {
                    print("Ошибка создания чата: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                self.setMessage(uid: uid, convoId: convoId, message: message, otherUser: otherUser) { success in
                    completion(success ? convoId : nil)
                }
            }
    }
   
//MARK: - Существующий чат
    private func setMessage(uid: String, convoId: String, message: String, otherUser: Sender, completion: @escaping (Bool) -> Void) {

        guard !uid.isEmpty, !convoId.isEmpty, !otherUser.senderId.isEmpty else {
            completion(false)
            return
        }

        let messageData: [String: Any] = [
            "date": Timestamp(date: Date()),
            "message": message,
            "senderId": uid,
            "otherId": otherUser.senderId
        ]

        Firestore.firestore()
            .collection(.conversation)
            .document(convoId)
            .collection(.messages)
            .document(UUID().uuidString)
            .setData(messageData) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                
          let selfLastMessage: [String: Any] = [
            "name": otherUser.displayName,
            "otherId": otherUser.senderId,
            "lastMessage": message,
            "date": Timestamp(date: Date()),
            "hasUnreadMessages": false
        ]
                
           Firestore.firestore()
                    .collection(.users)
                    .document(uid)
                    .collection(.conversation)
                    .document(convoId)
                    .setData(selfLastMessage) { error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                            completion(false)
                            return
                        }
                        
               let otherUserLastMessage: [String: Any] = [
                "name":  Service.shared.getUserName(),
                "otherId": uid,
                "lastMessage": message,
                "date": Timestamp(date: Date()),
                "hasUnreadMessages": true
            ]
                        
               Firestore.firestore()
                            .collection(.users)
                            .document(otherUser.senderId)
                            .collection(.conversation)
                            .document(convoId)
                            .setData(otherUserLastMessage) { error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                    completion(false)
                                    return
                                }
                                completion(true)
                            }
                    }
            }
    }
}

