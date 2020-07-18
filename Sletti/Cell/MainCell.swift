//
//  MainCell.swift
//  Sletti
//
//  Created by Arsalan Iravani on 09.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
    }
}





