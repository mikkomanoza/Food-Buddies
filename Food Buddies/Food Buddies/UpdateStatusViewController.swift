//
//  UpdateStatusViewController.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import FirebaseStorage
import UIKit

class UpdateStatusViewController: UIViewController {

    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadedImage: UIImageView!

    var imagePicker: UIImagePickerController!
    var imageSelected = false


    // MARK: - Overriding

    override func viewDidLoad() {
        super.viewDidLoad()

        //UITextField Placeholder

        tableView.delegate = self
        tableView.dataSource = self

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }


    // MARK: - Stored (IBAction)

    @IBAction func cancelUpdateStatus(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func postUpdateStatus(_ sender: UIBarButtonItem) {

        // TODO: - This always return true

        guard let caption = statusTextView.text, caption != nil else {
            Logger.w(message: "caption must be entered")
            presentDismissableAlertController(title: "Error Post", message: "caption must be entered")
            return
        }

        guard let image = uploadedImage.image, imageSelected == true else {
            Logger.w(message: "An image must be selected")
            presentDismissableAlertController(title: "Error Post", message: "An image must be selected")
            return
        }


        if let imageData = UIImageJPEGRepresentation(image, 0.2) {

            let imageUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"

            // POST THE UPLOADED IMAGE TO FIREBASE

            DataService.dataService.REF_POST_IMAGE.child(imageUid).put(imageData,metadata: metaData) { [weak self] (metadata, error) in
                if error != nil {
                    Logger.e(message: "Unable to upload image to Firebase Storage")
                    self?.presentDismissableAlertController(title: error?.localizedDescription, message: "Unable to upload image to Firebase Storage")
                } else {
                    Logger.i(message: "Successfully uploaded image to Firebase Storage")

                    guard let downloadURL = metadata?.downloadURL()?.absoluteString else {
                        Logger.e(message: "can't reference the downloadURL")
                        return
                    }

                    self?.postToFirebase(imageUrl: downloadURL)
                }
            }
        }

    }

    private func postToFirebase(imageUrl: String) {

        let post: Dictionary<String, AnyObject> = [
            "caption": statusTextView.text as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject
        ]

        // childByAutoId Create new id for us.
        let firebasePost = DataService.dataService.REF_POST.childByAutoId()
        firebasePost.setValue(post)

        statusTextView.text = ""
        imageSelected = false
        uploadedImage.image = UIImage(named: "camera")

        // DONOT FORGET THIS: This always update the UItableView For new Post
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }

}

extension UpdateStatusViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Upload Photo Cell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(imagePicker, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "MORE"
        }

        return nil
    }
}

extension UpdateStatusViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - ImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            uploadedImage.image = image
            imageSelected = true
        } else {
            presentDismissableAlertController(title: "A valid image wasn't selected", message: nil)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
