//
//  ProfilHeaderCollectionViewCell.swift
//  InstagramKloneApp
//
//  Created by Christian on 02.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit
import SDWebImage

protocol ProfilHeaderCollectionViewCellDelegate {
     func goToSettingVC()
}

class ProfilHeaderCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var delegate: ProfilHeaderCollectionViewCellDelegate?
    
    var user: UserModel? {
        didSet {
            
            guard let _user = user else { return }
            setupUserInformation(user: _user)
        }
    }
    
    func setupUserInformation(user: UserModel) {
        usernameLabel.text = user.username
        
        guard let url = URL(string: user.profilImageUrl!) else { return }
        profilImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
        
        PostApi.shared.fetchCountPosts(withUid: user.uid!) { (postCount) in
            self.postCountLabel.text = "\(postCount)"
        }
        
        FollowApi.shared.fetchFollowingCount(withUser: user.uid!) { (followingCount) in
            self.followingCountLabel.text = "\(followingCount)"
        }
        
        FollowApi.shared.fetchFollowerCount(withUser: user.uid!) { (followerCount) in
            self.followersCountLabel.text = "\(followerCount)"
        }
        
        if user.uid == UserApi.shared.CURRENT_USER_UID {
            editButton.setTitle("Settings", for: UIControl.State.normal)
            
            editButton.addTarget(self, action: #selector(goToSettings), for: UIControl.Event.touchUpInside)
            
        } else {
            if user.isFollowing! == true {
                setupFollowButton()
            } else {
                setupUnFollowButton()
            }
        }
    }
    
    @objc func goToSettings() {
//        print("Go to Settings")
        delegate?.goToSettingVC()
    }
    
    
    // MARK: Follow / UnFollow
    func setupFollowButton() {
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.cornerRadius = 5
        editButton.clipsToBounds = true
        
        editButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        editButton.backgroundColor = UIColor.white
        editButton.setTitle("Folge: ✔︎", for: UIControl.State.normal)
    }
    
    func setupUnFollowButton() {
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.cornerRadius = 5
        editButton.clipsToBounds = true
        
        editButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        editButton.backgroundColor = UIColor.white
        editButton.setTitle("Folge: ✖︎", for: UIControl.State.normal)
    }
    
    
    
   
    override func awakeFromNib() {
        profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
        editButton.layer.cornerRadius = 5
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
