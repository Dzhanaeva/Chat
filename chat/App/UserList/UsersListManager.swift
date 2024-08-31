//
//  UsersListManager.swift
//  chat
//
//  Created by Гидаят Джанаева on 11.08.2024.
//

import UIKit
import Firebase
import FirebaseFirestore

class UsersListManager {
    
    private let ref = Firestore.firestore()
    private var lastDoc: DocumentSnapshot?
    
    func getAllUser(completion: @escaping ([ChatUser]) -> Void) {
        var query: Query?
        if lastDoc == nil {
            query = ref
                .collection(.users)
                .limit(to: 10)
        } else {
            query = ref
                .collection(.users)
            .limit(to: 10)
            .start(afterDocument: lastDoc!)
        }

        query!
            .getDocuments { snap, err in
                guard err == nil else { return }
                guard let docs = snap?.documents else { return }
                self.lastDoc = docs.last
                
                var users: [ChatUser] = []
                docs.forEach { user in
                    
                    let userData = user.data()
                    if Service.shared.getUserId()?.uid != user.documentID {
                        let user = ChatUser(uid: user.documentID, userInfo: userData)
                        users.append(user)
                    }
                }
                completion(users)
            }
    }

    
    func getConvoId(otherId: String, completion: @escaping (String) -> ()) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Firestore.firestore()
            
            ref
                .collection(.users)
                .document(uid)
                .collection(.conversation)
                .whereField("otherId", isEqualTo: otherId)
                .getDocuments { snap, err in
                    if err != nil {
                        return
                    }
                    if let snap = snap, !snap.documents.isEmpty {
                        let doc = snap.documents.first
                        if let convoId = doc?.documentID {
                            completion(convoId)
                        }
                    }
                }
        }
            
    }
}
