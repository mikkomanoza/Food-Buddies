//
//  RoundedUIViewForBadge.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 27/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

class RoundedUIViewForBadge: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}
