//
//  MessangerPresent.swift
//  chat
//
//  Created by Гидаят Джанаева on 10.08.2024.
//

import UIKit
import MessageKit
import FirebaseFirestoreInternal

protocol MessangerPresenterProtocol: AnyObject {
    var title: String { get set }
    var selfSender: Sender { get set }
    var messages: [Message] { get set }
    var convoId: String? { get set }
    var otherId: String { get set}
    func sendMessage(message: Message)
    func getMessages(convoId: String)
}

class MessangerPresenter: MessangerPresenterProtocol {
    
    var messages: [Message]
    weak var view: MessangerViewProtocol?
    var convoId: String?
    var title: String
    var otherId: String
    private let messageSendManager = MessageSendManager()
    private let getMessagesManager = GetMessagesManager()
    var selfSender: Sender
    
    private lazy var otherSender = Sender(senderId: otherId, displayName: title)
    
 
    init(view: MessangerViewProtocol?, convoId: String?, otherId: String, name: String) {
        self.view = view
        self.convoId = convoId
        self.title = name
        self.otherId = otherId
        self.messages = [] 
        
        self.selfSender = Sender(senderId: (Service.shared.getUserId()?.uid)!, displayName: Service.shared.getUserName())

        if convoId != nil {
            getMessages(convoId: convoId!)
            loadLastMessage(convoId: convoId!)

            }
        }
    
 
    func sendMessage(message: Message) {
        switch message.kind {
        case .text(let text):
            messageSendManager.sendMessage(convoId: convoId, message: text, otherUser: otherSender) { [weak self] convoId in
                guard let self = self else { return }
                guard let convoId else { return }
                self.convoId = convoId
            }
        default:
            break
            
        }
    }
    
    func getMessages(convoId: String){
        getMessagesManager.getAllMessage(convoId: convoId) { [weak self] message in
            guard let self = self else { return }
            self.messages = message
            self.view?.reloadCollection()
        }
    }
    
    private func loadLastMessage(convoId: String){
        getMessagesManager.loadOneMessage(convoId: convoId) { [weak self] message in
            guard let self = self else { return }
            
            if message.sender.senderId != selfSender.senderId {
                self.messages.append(message)
                view?.reloadCollection()
            }
        }
    }
}
