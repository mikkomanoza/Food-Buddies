//
//  Services.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class DataService {

    static let dataService = DataService()

    // MARK: - DATABASE REFERENCE

    private var referenceBase = Constant.FIREBASE_DATABASE_BASE
    private var referencePost = Constant.FIREBASE_DATABASE_BASE.child("posts")
    private var referenceUser = Constant.FIREBASE_DATABASE_BASE.child("users")


    // MARK: - STORAGE REFERENCE

    private var referencePostImages = Constant.FIREBASE_STORAGE_BASE.child("post-pictures")


    var REF_BASE: FIRDatabaseReference {
        return referenceBase
    }

    var REF_POST: FIRDatabaseReference {
        return referencePost
    }

    var REF_USER: FIRDatabaseReference {
        return referenceUser
    }

    var REF_POST_IMAGE: FIRStorageReference {
        return referencePostImages
    }

    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: Constant.KEY_UID)
        let user = REF_USER.child(uid!)
        return user
    }

    private func createFIrebaseDatabaseUser(uid: String, userData: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(userData)
    }
}
