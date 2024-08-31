//
//  Service.swift
//  chat
//
//  Created by Гидаят Джанаева on 14.07.2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Service {
    static let shared = Service()
    
    init() {}
    
    func getUserId() -> User? {
        guard let user = Auth.auth().currentUser else { return nil }
        return user
    }
    
    func getUserName() -> String {
        return UserDefaults.standard.string(forKey: "selfName") ?? ""
    }
 
    
    func checkAuthState() {
        if let user = Auth.auth().currentUser {
            print("User is signed in with UID: \(user.uid)")
        } else {
            print("No user is signed in.")
        }
    }
    
    
    func isLogin() -> Bool {

        return Auth.auth().currentUser?.uid == nil ? false : true

    }
    
    
    // MARK: - Выход
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
        
    }
    
    //MARK: - Процесс регистрации
    
    func createNewUser(_ data: UserInfo, completion: @escaping (ResponceCode)->()) {
        
        Auth.auth().createUser(withEmail: data.email, password: data.password) {  result, err in
            if err == nil {
                if result != nil {
                    let userId = result?.user.uid
                    let email = data.email
                    let name = data.name
                    let data: [String: Any] = ["email": email, "name": name]
                    Firestore.firestore().collection(.users).document(userId!).setData(data)
                    
                    completion(ResponceCode(code: 1))
                    
                }
            } else {
                completion(ResponceCode(code: 0))
                
            }
        }
    }
    
    
    
    func confirmEmail() {
        Auth.auth().currentUser?.sendEmailVerification(completion: {  err in
            if err != nil {
                print(err!.localizedDescription)
            }
        })
    }
    
  //MARK: - Процесс авторизации
    
    func authApp(userInfo: UserInfo, completion: @escaping (AuthResponce) -> Void) {
        Auth.auth().signIn(withEmail: userInfo.email, password: userInfo.password) { [weak self] result, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                completion(.error)
                return
            }
            
            guard let user = result?.user else {
                completion(.error)
                return
            }
     
            Firestore.firestore()
                .collection(.users)
                .document(user.uid)
                .getDocument { snap, err in
                    guard err == nil else { 
                        completion(.error)
                        return }
                    if let userData = snap?.data() {
                        
                        let name = userData["name"] as? String ?? userInfo.name
                        UserDefaults.standard.set(name, forKey: "selfName")
                        
                        if user.isEmailVerified {
                            completion(.success)
                        } else {
                            self?.confirmEmail()
                            completion(.noVerifity)
                        }
                    }
                }
        }
    }
}





