//
//  LoaderViewController.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 29/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {

    @IBOutlet weak var loadingGIF: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingGIF.loadGif(name: "cats")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
