//
//  ViewController.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import AVFoundation
import FirebaseAuth
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var videoView: UIView!

    // MARK: Stored

    var player: AVPlayer?


    // MARK: - Overriding

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    // MARK: - Stored (IBAction)

    @IBAction func facebookLogin(_ sender: Any) {

        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in

            if result == nil {
                guard let errorMessage = error?.localizedDescription else {
                    return
                }

                Logger.i(message: errorMessage)
                self.presentDismissableAlertController(title: error?.localizedDescription, message: nil)

            } else if result!.isCancelled {
                self.presentDismissableAlertController(title: "Error: Cancelled facebook authentication", message: nil)
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                Logger.i(message: "\(credential)")
            }
        })
    }


    // MARK: - Instance

    private func firebaseAuth(_ credential: FIRAuthCredential) {
        let loadingAlertController = presentLoadingAlertController(title: "Signing in...")
        FIRAuth.auth()?.signIn(with: credential) { [weak self, weak loadingAlertController] (user, error) in

            if error == nil {
                loadingAlertController?.dismiss(animated: true, completion: { 
                    self?.performSegue(withIdentifier: "showHome", sender: self)
                })

                if let user = user {
                    self?.completeSignIn(id: user.uid)
                }

            } else {
                self?.presentDismissableAlertController(title: error?.localizedDescription, message: nil)
            }
        }
    }

//    private func saveUserToFirebase(username: String) {
//
//        let saveUser: Dictionary<String, String> = [
//            "name": username as String
//        ]
//
//        let firebaseSaveUser = DataService.dataService.REF_USER_CURRENT.child("likes")
//        Logger.i(message: "gg \(DataService.dataService.REF_USER_CURRENT)")
//
//        firebaseSaveUser.setValue(saveUser)
//    }

    private func facebookGraph() {

        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["public_profile": "email, name"])
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { [weak self] (connection, result, error) in
            if let error = error {
                Logger.e(message: "\(error.localizedDescription)")
            } else {
                if let userDetails = result as? [String: String] {

                    let userID = userDetails["id"]! as NSString
                    let facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"

                    guard let username = userDetails["name"] else {
                        return
                    }

                    Logger.i(message: "this is the profile id: \(facebookProfileUrl)")
                }
            }
        })
        
        connection.start()
    }

    // Saved the UID to Keychain
    private func completeSignIn(id: String) {
        let keyChainKeyUID = KeychainWrapper.standard.set(id, forKey: Constant.KEY_UID)
        Logger.i(message: "Successfully saved the KeychainUID: \(keyChainKeyUID)")
    }
}
