//
//  UIViewController.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

extension UIViewController {

    @discardableResult
    func presentDismissableAlertController(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)

        alertController.addAction(dismissAlertAction)

        present(alertController, animated: true, completion: nil)

        return alertController
    }

    func presentLoadingAlertController(title: String? = "Loading...", completion: (() -> Swift.Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: "Please wait.", preferredStyle: .alert)

        present(alertController, animated: true, completion: completion)

        return alertController
    }
}
