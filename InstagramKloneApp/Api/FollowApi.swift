//
//  FollowApi.swift
//  InstagramKloneApp
//
//  Created by Christian on 05.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    // Adressen zur Datenbank
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    // Singleton pattern (Einzelstück Muster)
    static let shared: FollowApi = FollowApi()
    private init() {
    }
    
    // Jemanden folgen
    func followAction(withUser uid: String) {
        let currentUserUid = UserApi.shared.CURRENT_USER_UID!
        
        PostApi.shared.REF_MY_POSTS.child(uid).observe(.value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            for postId in dic.keys {
                FeedApi.shared.REF_NEWSFEED.child(currentUserUid).child(postId).setValue(true)
            }
        }
        REF_FOLLOWERS.child(uid).child(currentUserUid).setValue(true)
        REF_FOLLOWING.child(currentUserUid).child(uid).setValue(true)
    }
    
    // Jemanden nicht mehr folgen
    func unFollowAction(withUser uid: String) {
        let currentUserUid = UserApi.shared.CURRENT_USER_UID!
        
        PostApi.shared.REF_MY_POSTS.child(uid).observe(.value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            for postId in dic.keys {
                FeedApi.shared.REF_NEWSFEED.child(currentUserUid).child(postId).removeValue()
            }
        }
        
        
        REF_FOLLOWERS.child(uid).child(currentUserUid).setValue(NSNull())
        REF_FOLLOWING.child(currentUserUid).child(uid).setValue(NSNull())
    }
    
    // Überprüft ob der akutelle eingeloggt user dem User mit der id... folgt oder nicht
    func isFollowing(withUser uid: String, completed: @escaping(Bool) -> Void) {
        let currentUserUId = UserApi.shared.CURRENT_USER_UID!
        REF_FOLLOWERS.child(uid).child(currentUserUId).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        }
    }
    
    // Anzahl following
    func fetchFollowingCount(withUser id: String, completion: @escaping (UInt) -> Void) {
        REF_FOLLOWING.child(id).observe(.value) { (snapshot) in
            let followingCount = snapshot.childrenCount
            completion(followingCount)
        }
    }
    
    // Anzahl follower
    func fetchFollowerCount(withUser id: String, completion: @escaping (UInt) -> Void) {
        REF_FOLLOWERS.child(id).observe(.value) { (snapshot) in
            let followerCount = snapshot.childrenCount
            completion(followerCount)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
