//
//  UserApi.swift
//  InstagramKloneApp
//
//  Created by Christian on 28.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    // Adresse Datenbank users
    var REF_USERS = Database.database().reference().child("users")
    
    // Singleton pattern (Einzelstück Muster)
    static var shared: UserApi = UserApi()
    private init() {
    }
    
    // Aktuell eingeloggte User ID
    var CURRENT_USER_UID: String? {
        if let currentUserUid = Auth.auth().currentUser?.uid {
            return currentUserUid
        }
        return nil
    }
    
    // Aktuell eingeloggte User
    var CURRENT_USER: User? {
        if let currentUserUid = Auth.auth().currentUser {
            return currentUserUid
        }
        return nil
    }
    
    // Lade User mit der id
    func observeUser(uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newUser = UserModel(dictionary: dic)
            completion(newUser)
        }
    }
    
    // Lade user ohne id
    func observeUser(completion: @escaping (UserModel) -> Void ) {
        REF_USERS.observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let user = UserModel(dictionary: dic)
            completion(user)
        }
    }
    
    // Lade den aktuellen User
    func observeCurrentUser(completion: @escaping (UserModel) -> Void ) {
        guard let currentUserUid = CURRENT_USER_UID else { return }
        REF_USERS.child(currentUserUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let currentUser = UserModel(dictionary: dic)
            completion(currentUser)
        }
    }
    
    // User im Suchfeld laden
    func queryUser(withText text: String, completion: @escaping(UserModel) -> Void ) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text + "\u{f8ff}").queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach({ (data) in
                let child = data as! DataSnapshot
                guard let dic = child.value as? [String: Any] else { return }
                let user = UserModel(dictionary: dic)
                completion(user)
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
