//
//  CityServiceCell.swift
//  Carento
//
//  Created by Tuan Anh Vu on 10/16/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import UIKit

class CityServiceCell: UITableViewCell {
    
    @IBOutlet weak var imvImage: UIImageView!
    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    
    @IBOutlet weak var subBackgroundView: UIView!
    
    @IBOutlet weak var widthOfIcon: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        subBackgroundView.layer.masksToBounds = true
        subBackgroundView.layer.cornerRadius = 5.0
        subBackgroundView.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        subBackgroundView.layer.shadowOpacity = 0.5
        subBackgroundView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        subBackgroundView.layer.shadowRadius = 3.0
        subBackgroundView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
