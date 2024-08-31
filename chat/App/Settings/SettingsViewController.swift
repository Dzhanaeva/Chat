//
//  SettingsViewController.swift
//  chat
//
//  Created by Гидаят Джанаева on 16.07.2024.
//

import UIKit
import Firebase
import FirebaseFirestore

class SettingsViewController: UIViewController {
 
    private var userListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Two")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTapped))
        changeNameIcon.isUserInteractionEnabled = true
        changeNameIcon.addGestureRecognizer(tapGesture)
        
        view.addSubviews(signOutBtn, topView)
        topView.addSubviews(labelName, icon, changeNameIcon)
        
        setConstraint()
        setupUserListener()

    }
    
    deinit {
        userListener?.remove()
    }
    
    
    @objc func changeTapped() {
        presentChangeNameAlert()
    }
    
    //MARK: - UI
    
    lazy var topView: UIView = {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 50
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return $0
    }(UIView())
    
    
    lazy var labelName: UILabel = {
        $0.text = Service.shared.getUserName()
        $0.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        $0.textColor = UIColor(named: "Four")
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var icon: UIImageView = {
        $0.image = UIImage(named: "iconUsers")
        $0.heightAnchor.constraint(equalToConstant: 120).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 120).isActive = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    lazy var changeNameIcon: UIImageView = {
        $0.image = UIImage(systemName: "pencil.line")
        $0.heightAnchor.constraint(equalToConstant: 27).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 27).isActive = true
        $0.tintColor = .darkGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
//MARK: - Alert смена имени
    func presentChangeNameAlert() {
        
        let alert = UIAlertController(title: .localize("changeName"), message: .localize("enterNewName"), preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = .localize("namePlaceholder")
            textField.text = self.labelName.text
            
            let cancelAction = UIAlertAction(title: .localize("alertCancel"), style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: .localize("alertSave"), style: .default) { [weak self] _ in
                if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                    self?.updateUserName(newName)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func saveNameToUserDefaults(_ name: String) {
        UserDefaults.standard.set(name, forKey: "selfName")
    }
    
    private func loadNameFromUserDefaults() {
        if let name = UserDefaults.standard.string(forKey: "selfName") {
            updateNameInUI(name)

        }
    }
    
    private func setupUserListener() {
        let ref  = Firestore.firestore()
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
        userListener = ref
            .collection(.users)
            .document(userID)
            .addSnapshotListener { [weak self] (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("ошибка при загрузке \(error!)")
                    return
                }
                guard let data = document.data() else { return }
                
            if let name = data["name"] as? String {
                self?.updateNameInUI(name)
                self?.saveNameToUserDefaults(name)
            }
            }
        }
    
    private func updateNameInUI(_ name: String) {
        DispatchQueue.main.async {
            self.labelName.text = name
        }
    }

    func updateUserName(_ newName: String) {
        let ref  = Firestore.firestore()
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
        let userRef = ref
            .collection(.users)
            .document(userID)
            
            userRef.updateData(["name": newName]) { [weak self] error in
                if let error = error {
                    print("Ошибка обновления имени: \(error)")
                } else {
                    self?.updateNameInUI(newName)
                    self?.saveNameToUserDefaults(newName)
                    print("успешно")
                    }
                }
            }
    
    //MARK: - Выход из системы
        
    lazy var signOutBtn: UIButton = Button(buttonText: .localize("btnLogOut"), buttonColor: .white, titleColor: .red, border: 0, borderColor: .none) {
        self.signOutBtn.addTarget(self, action: #selector(self.showSignOutAlert), for: .touchUpInside)
        print("выход")
            }

    @objc private func showSignOutAlert() {
        let alert = UIAlertController(title: .localize("alertLogOut"), message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: .localize("alertCancel"), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: .localize("alertYes"), style: .default) { [weak self] _ in
            self?.signOutTapped()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func signOutTapped() {
        Service.shared.signOut() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.navigateToFirstScreen()
                }
            case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        
                    }
                }
            }
        }
    
    func navigateToFirstScreen() {
        navigationController?.pushViewController(FirstScreen(), animated: true)
    }
    
    
//MARK: - Constraints
    func setConstraint() {
        NSLayoutConstraint.activate([
        
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             
            icon.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            labelName.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            labelName.centerXAnchor.constraint(equalTo: icon.centerXAnchor),
            labelName.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -27),
            
            changeNameIcon.leadingAnchor.constraint(equalTo: labelName.trailingAnchor, constant: 7),
            changeNameIcon.centerYAnchor.constraint(equalTo: labelName.centerYAnchor, constant: 4),
            

            signOutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signOutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signOutBtn.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 25),
            signOutBtn.heightAnchor.constraint(equalToConstant: 55)
            

        ])
    }

}


