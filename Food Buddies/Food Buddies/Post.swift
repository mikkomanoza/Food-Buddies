//
//  Post.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post {

    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postref: FIRDatabaseReference!

    private var _username: String!


    var caption: String {
        return _caption
    }

    var imageUrl: String {
        return _imageUrl
    }

    var likes: Int {
        return _likes
    }

    var username: String {
        return _username
    }

    var postKey: String {
        return _postKey
    }


    init(caption: String, imageUrl: String, likes: Int, postKey: String, username: String) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._username = username
    }


    init(postKey: String, postData: Dictionary<String, Any>) {

        self._postKey = postKey

        if let caption = postData["caption"] as? String {
            self._caption = caption
        }

        if let imgUrl = postData["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }

        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }

        if let username = postData["username"] as? String {
            self._username = username
        }

        _postref = DataService.dataService.REF_POST.child(_postKey)
    }


    func adjustLike(addLike: Bool) {

        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postref.child("likes").setValue(_likes)
    }
    
}
