//
//  ClipToBoundImageView.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 27/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

class ClipToBoundImageView: UIImageView {

    override func awakeFromNib() {
        self.clipsToBounds = true
    }
}
