//
//  CirclePhoto.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 27/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

class CirclePhoto: UIImageView {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 10.0
    }
}
