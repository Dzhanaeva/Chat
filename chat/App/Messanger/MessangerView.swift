//
//  MessangerView.swift
//  chat
//
//  Created by Гидаят Джанаева on 08.08.2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView

protocol MessangerViewProtocol: AnyObject {
    func reloadCollection()
}

class MessangerView: MessagesViewController, MessangerViewProtocol {
    
    var presenter: MessangerPresenterProtocol!
    let userListManager = UsersListManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.title
        
        showMessageTimestampOnSwipeLeft = true
        
        messagesSetup()
        configureInputBarSendButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    
    func messagesSetup() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.reloadDataAndKeepOffset()
        messagesCollectionView.register(MessageDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
        if presenter.convoId == nil {
            userListManager.getConvoId(otherId: presenter.otherId) { convoId in
                self.presenter.convoId = convoId
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter
    }()
    
    //MARK: - SendButton
    
    private func configureInputBarSendButton() {
        let button = InputBarButtonItem()
        
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .one
        
        button.onTouchUpInside { [weak self] _ in
            self?.handleSendButtonTap()
        }
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .right, animated: false)
    }
    
    private func handleSendButtonTap() {
        guard let text = messageInputBar.inputTextView.text, !text.isEmpty else { return }
        
        if let button = messageInputBar.rightStackView.arrangedSubviews.first as? InputBarButtonItem {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.2) {
                button.transform = .identity
            }
        }
        
        let message = Message(sender: presenter.selfSender,
                              messageId: UUID().uuidString,
                              sentDate: Date(),
                              kind: .text(text))
        
        insertMessage(message)
        presenter.sendMessage(message: message)
        messageInputBar.inputTextView.text = ""
    }
}
        

//MARK: - Extension

extension MessangerView: MessagesDataSource {
    
    var currentSender: any MessageKit.SenderType {
        presenter.selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        presenter.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        presenter.messages.count
    }
    
    private func insertMessage(_ message: Message) {
        presenter.messages.append(message)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([presenter.messages.count - 1])
            if presenter.messages.count >= 2{
                messagesCollectionView.reloadSections([presenter.messages.count - 2])
            }
        }, completion: { [weak self] _ in
            self?.messagesCollectionView.scrollToLastItem(animated: true)
        })
    }
    
    func reloadCollection() {
        messagesCollectionView.reloadDataAndKeepOffset()
    }
}


extension MessangerView: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        CGSize(width: 100, height: 1)
    }
    func backgroundColor(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        message.sender.senderId == presenter.selfSender.senderId ? .one : .systemGray5
    }

    func cellTopLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return shouldShowDateHeader(for: indexPath) ? 30 : 0
    }

    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        let message = messagesCollectionView.messagesDataSource!.messageForItem(at: indexPath, in: messagesCollectionView)
        let headerView = messagesCollectionView.dequeueReusableHeaderView(MessageDateHeaderView.self, for: indexPath)
        
        if shouldShowDateHeader(for: indexPath) {
            headerView.dateLabel.text = dateFormatter.string(from: message.sentDate)
        } else {
            headerView.dateLabel.text = nil
        }
        return headerView
    }
    
    private func shouldShowDateHeader(for indexPath: IndexPath) -> Bool {
        guard indexPath.section > 0 else { return true }
           
        let currentMessage = messagesCollectionView.messagesDataSource!.messageForItem(at: indexPath, in: messagesCollectionView)
        let previousIndexPath = IndexPath(item: 0, section: indexPath.section - 1)
        let previousMessage = messagesCollectionView.messagesDataSource!.messageForItem(at: previousIndexPath, in: messagesCollectionView)
           
        return currentMessage.sentDate.isDifferentDay(than: previousMessage.sentDate)
       }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.image = UIImage(named: "iconUsers")
    }
}


extension MessangerView: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if let button = inputBar.rightStackView.arrangedSubviews.first as? InputBarButtonItem {
            button.tintColor = text.isEmpty ? .one : .four
        }
    }
    
}


