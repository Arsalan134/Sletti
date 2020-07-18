//
//  TranslatorCell.swift
//  Sletti
//
//  Created by Arsalan Iravani on 14.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit

class TranslatorCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
