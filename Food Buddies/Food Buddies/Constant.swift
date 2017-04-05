//
//  Constant.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

struct Constant {

    static let FIREBASE_DATABASE_BASE = FIRDatabase.database().reference()
    static let FIREBASE_STORAGE_BASE = FIRStorage.storage().reference()
    static let KEY_UID = "uid"
}
