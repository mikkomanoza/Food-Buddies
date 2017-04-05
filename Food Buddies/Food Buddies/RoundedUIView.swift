//
//  RoundedUIView.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 27/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//

import UIKit

class RoundedUIView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}
