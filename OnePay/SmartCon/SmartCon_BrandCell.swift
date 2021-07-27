//
//  SmartCon_BrandCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 4. 5..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class SmartCon_BrandCell: UITableViewCell {

    @IBOutlet weak var brandCell_MenuImage: UIImageView!
    @IBOutlet weak var brandCell_BrandName: UILabel!
    @IBOutlet weak var brandCell_BrandDetail: UILabel!
    @IBOutlet weak var brandCell_MenuPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
