//
//  RoundedUIButton.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 27/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

class RoundedUIButton: UIButton {

    override func awakeFromNib() {
        self.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        self.layer.cornerRadius = 0.4 * self.bounds.size.width
        self.clipsToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
    }
}
