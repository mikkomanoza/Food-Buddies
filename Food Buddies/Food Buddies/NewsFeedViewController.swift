//
//  NewsFeedViewController.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import DGElasticPullToRefresh

class NewsFeedViewController: UIViewController {

    // Stored

    var posts = [Post]()
    var imagePicker: UIImagePickerController!

    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var postCell = PostTableViewCell()
    var loadingView = DGElasticPullToRefreshLoadingViewCircle()


    // MARK: - Stored (IBOutlet)

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userProfilePicture: UIImageView!


    // MARK: - Overriding

    override func viewDidLoad() {
        super.viewDidLoad()

        // FIREBASE DATABASE

        DataService.dataService.REF_POST.observe(.value, with: { [weak self] (snapchat) in
            Logger.i(message: "\(snapchat.value)")

            self?.tableView.dg_stopLoading()

            if let snapshots = snapchat.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDictionary)
                        self?.posts.append(post)
                    }
                }

                self?.tableView.reloadData()
            }
        })

        tableView.delegate = self
        tableView.dataSource = self

        elasticPullToRefresh()
    }

    deinit {
        tableView.dg_removePullToRefresh()
    }

    // MARK: - Stored (IBAction)

    @IBAction func updateStatus(_ sender: UITapGestureRecognizer) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"Update Status")
        self.present(viewController, animated: true)
    }


    private func refresh() {
        loadingView.startAnimating()
        tableView.reloadData()
    }

    private func elasticPullToRefresh() {

        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in

            self?.refresh()

            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 237/255.0, green: 154/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeed_cell") as? PostTableViewCell {

            if let img = NewsFeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
                    cell.configureCell(posts: post, image: img)
                } else {
                    cell.configureCell(posts: post)
                }

                return cell

        } else {
            return PostTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
