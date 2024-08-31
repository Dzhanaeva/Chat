//
//  UserListViewController.swift
//  chat
//
//  Created by Гидаят Джанаева on 16.07.2024.
//

import UIKit
import Firebase
import FirebaseFirestore


class UserListViewController: UIViewController {
    
    private let userListManager = UsersListManager()
    var users: [ChatUser] = []
    var searchUsers: [ChatUser] = []
    
    var isSearching: Bool {
        return !searchBar.text!.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Two")
        
        view.addSubviews(headerLabel, usersTableView, searchBar)
       
        setupConstraints()
        getUserList()
        }

    //MARK: - UI
    
    lazy var searchBar: UISearchBar = {
        $0.searchBarStyle = .minimal
        $0.placeholder = .localize("searchPlaceholder")
        $0.searchTextField.font = .systemFont(ofSize: 15)
        $0.searchTextField.textColor = .lightGray
        $0.delegate = self
        $0.tintColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UISearchBar())
    
    lazy var usersTableView: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.dataSource = self
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .two
        $0.scrollsToTop = true
        $0.tableHeaderView = usersLabel
        $0.rowHeight = 60

        return $0
    }(UITableView(frame: view.bounds, style: .grouped))
    
     lazy var usersLabel: UILabel = {
         $0.text = .localize("tabTextFriends")
         $0.font = .systemFont(ofSize: 27, weight: .semibold)
         $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var headerLabel: UILabel = {
        $0.font = .systemFont(ofSize: 35, weight: .bold)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Freechat"
        return $0
    }(UILabel())

    //MARK: - Данные
    func getUserList() {
        userListManager.getAllUser { [weak self] users in
            guard let self = self else { return }
            self.users = users
            self.searchUsers = users
            self.reloadTable()

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
                
         usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         usersTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
         usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
         usersLabel.leadingAnchor.constraint(equalTo: usersTableView.leadingAnchor, constant: 15),
         usersLabel.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
}

//MARK: - Extensions TableView

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cellItem = isSearching ? searchUsers[indexPath.row] : users[indexPath.row]

       
        var config = cell.defaultContentConfiguration()
        config.textProperties.font = .systemFont(ofSize: 19, weight: .medium)
        config.text = cellItem.name
        config.image = UIImage(named: "iconUsers")

        cell.contentConfiguration = config
        
        cell.backgroundColor = .two
        return cell
    }
    
    func reloadTable() {
        usersTableView.reloadData()
    }
    
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = isSearching ? searchUsers[indexPath.row] : users[indexPath.row]
        
        checkIfChatExists(with: selectedUser.id) { [weak self] convoId in
            guard let self = self else { 
                print("найден")
                return }
            
            let chatItem = ChatItem(convoId: convoId, name: selectedUser.name, otherUserId: selectedUser.id, date: Date(), lastMessage: nil)
            let messangerController = Builder.getMessangerView(chatItem: chatItem)
            navigationController?.pushViewController(messangerController, animated: true)
        }
    }
    
    func checkIfChatExists(with userId: String, completion: @escaping (String?) -> Void) {
        guard let currentUserId = Service.shared.getUserId()?.uid else {
            completion(nil)
            return
        }
        
        let ref = Firestore.firestore()
        ref.collection(.conversation)
            .whereField("users", arrayContains: currentUserId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(nil)
                    return
                }
                
                for document in documents {
                    let data = document.data()
                    if let users = data["users"] as? [String], users.contains(userId) {
                        completion(document.documentID)
                        return
                    }
                }
                completion(nil)
                print("не найден")
            }
    }
}


//MARK: - Extension UISearchBar

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
                   searchUsers = users
               } else {
                   searchUsers = users.filter { $0.name.lowercased().contains(searchText.lowercased()) }
               }
               usersTableView.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchUsers = users
        usersTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

