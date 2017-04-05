//
//  PostTableViewCell.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import FBSDKLoginKit
import FirebaseStorage
import FirebaseDatabase
import GSImageViewerController
import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeView: UIView!

    var post: Post!
    var likesRef: FIRDatabaseReference!
    var imgs: UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.like(sender:)))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)

        facebookGraph()
    }

    func configureCell(posts: Post, image: UIImage? = nil) {
        self.post = posts
        self.captionLabel.text = posts.caption
        self.likesLabel.text = "\(posts.likes) Likes"

        likesRef = DataService.dataService.REF_USER_CURRENT.child("likes").child(post.postKey)

        if image != nil {
            self.postImage.image = image
        } else {

            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize:1 * 1024 * 1024, completion: { (data, error) in

                if error != nil {
                    Logger.e(message: "Unable to download image from firebase storage")
                } else {
                    Logger.i(message: "image downloaded from firebase storage")
                    if let imageData = data {
                        if let imgs = UIImage(data: imageData) {
                            self.postImage.image = imgs
                            NewsFeedViewController.imageCache.setObject(imgs, forKey: self.post.imageUrl as NSString)
                            self.imgs = imgs
                        }
                    }}

            })
        }


        // DEFAULT LIKE


        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "hearts_unfilled")
            } else {
                self.likeImage.image = UIImage(named: "hearts_filled")
            }
        })
    }

    // LIKES

    func like(sender: UITapGestureRecognizer) {

        let likesRef = DataService.dataService.REF_USER_CURRENT.child("likes")

        likesRef.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self?.likeImage.image = UIImage(named: "hearts_filled")
                self?.post.adjustLike(addLike: true)
                self?.likesRef.setValue(true)

                Logger.i(message: "Success: You called me")

            } else {
                self?.likeImage.image = UIImage(named: "hearts_unfilled")
                self?.post.adjustLike(addLike: false)
                self?.likesRef.removeValue()

                Logger.i(message: "Error: You called nothing")
            }
        })
    }


    private func facebookGraph() {

        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["public_profile": "email, name"])
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { [weak self] (connection, result, error) in
            if let error = error {
                Logger.e(message: "\(error.localizedDescription)")
            } else {
                if let userDetails = result as? [String: String] {

                    guard let username = userDetails["name"] else {
                        return
                    }

                    self?.userNameLabel.text = username

                    let userID = userDetails["id"]! as NSString
                    let facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"

                    Logger.i(message: "this is the profile id: \(facebookProfileUrl)")
                    //Logger.i(message: "this is the profile username: \(username)")

                    //self?.downloadImage(urlString: facebookProfileUrl)
                }
            }
        })
        
        connection.start()
    }

}

