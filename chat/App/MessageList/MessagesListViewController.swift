//
//  AppViewController.swift
//  chat
//
//  Created by Гидаят Джанаева on 04.07.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class MessagesListViewController: UIViewController {
    
    var chatList: [ChatItem] = []
    var searchUsers: [ChatItem] = []
    private let messageListManager = MessagesListManager()
    var isSearching: Bool {
        return !searchBar.text!.isEmpty
    }
   
    //MARK: - DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .two
        
        view.addSubviews(headerLabel, messageTableView, searchBar)
        
        setupConstraints()
        getChatList()
//        setupNewMessageListener()
    }
    
    //MARK: - DidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTableView.reloadData()
    }

    //MARK: - UI

    lazy var messageTableView: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.dataSource = self
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .two
        $0.scrollsToTop = true
        $0.tableHeaderView = meassagesLabel
        $0.rowHeight = 60

        return $0
    }(UITableView(frame: view.bounds, style: .grouped))
    
    lazy var headerLabel: UILabel = {
        $0.font = .systemFont(ofSize: 35, weight: .bold)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Freechat"
        return $0
    }(UILabel())
    
    lazy var searchBar: UISearchBar = {
        $0.searchBarStyle = .minimal
        $0.placeholder = .localize("searchPlaceholder")
        $0.searchTextField.font = .systemFont(ofSize: 15)
        $0.searchTextField.textColor = .lightGray
        $0.tintColor = .one
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UISearchBar())
    
    private lazy var meassagesLabel: UILabel = {
        $0.text = .localize("tabTextMessages")
        $0.font = .systemFont(ofSize: 27, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    //MARK: - Данные
    func getChatList() {
        messageListManager.getChatList { [ weak self ] chatList in
            guard let self = self else { return }
            
            self.chatList = chatList
            self.searchUsers = chatList
            self.reloadTable()
            
        }
    }
    
    
    //MARK: - Непрочитанные сообщения
    
    func updateUnreadStatus(for chatId: String, hasUnread: Bool) {
        if let index = chatList.firstIndex(where: { $0.convoId == chatId }) {
            chatList[index].hasUnreadMessages = hasUnread
            
            if let searchIndex = searchUsers.firstIndex(where: { $0.convoId == chatId }) {
                searchUsers[searchIndex].hasUnreadMessages = hasUnread
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let visibleRows = self.messageTableView.indexPathsForVisibleRows,
                   visibleRows.contains(IndexPath(row: index, section: 0)) {
                    self.messageTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
    

    //MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
        
            messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            meassagesLabel.leadingAnchor.constraint(equalTo: messageTableView.leadingAnchor, constant: 15),
            meassagesLabel.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
}

//MARK: - Extesion TableView
extension MessagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchUsers.count : chatList.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let chatItem = isSearching ? searchUsers[indexPath.row] : chatList[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = chatItem.name
        config.image = UIImage(named: "iconUsers")
        config.secondaryText = chatItem.lastMessage?.truncate(to: 110)
        
        if chatItem.hasUnreadMessages {
            
            config.textProperties.font = .systemFont(ofSize: 16, weight: .bold)
            config.secondaryTextProperties.font = .systemFont(ofSize: 12, weight: .bold)
            let unreadIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            unreadIndicator.backgroundColor = .four
            unreadIndicator.layer.cornerRadius = 5
            cell.accessoryView = unreadIndicator
            
        } else {
            config.textProperties.color = .label
            config.secondaryTextProperties.color = .secondaryLabel
            cell.accessoryView = nil
        }
        
        cell.backgroundColor = .two
        cell.contentConfiguration = config
        
        return cell
    }
    
    func reloadTable() {
        messageTableView.reloadData()
    }
}
    
    extension MessagesListViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let selectedUser = isSearching ? searchUsers[indexPath.row] : chatList[indexPath.row]
            print(chatList[indexPath.row].convoId ?? "")

            updateUnreadStatus(for: selectedUser.convoId ?? "", hasUnread: false)
            markMessagesAsRead(for: selectedUser.convoId ?? "")
            
            let messangerController = Builder.getMessangerView(chatItem: selectedUser)
            navigationController?.pushViewController(messangerController, animated: true)

        }
        
        private func markMessagesAsRead(for convoId: String) {
            guard let uid = Service.shared.getUserId()?.uid else { return }
            
            let userConversationRef = Firestore.firestore()
                .collection(.users)
                .document(uid)
                .collection(.conversation)
                .document(convoId)
            
            userConversationRef.updateData(["hasUnreadMessages": false]) { error in
                if let error = error {
                    print("Статус сообщения: \(error.localizedDescription)")
                } else {
                    print("Статус сообщения успешно обновлен")
                }
            }
        }
    }


//MARK: - Extension UISearchBar
extension MessagesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchUsers = chatList
        } else {
            searchUsers = chatList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        messageTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchUsers = chatList
        messageTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}


