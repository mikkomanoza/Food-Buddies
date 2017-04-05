//
//  CircleButton.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
//        self.layer.borderWidth = 3
//        self.layer.borderColor = UIColor.white.cgColor
    }
}
