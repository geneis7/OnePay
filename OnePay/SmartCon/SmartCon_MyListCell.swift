//
//  SmartCon_MyListCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 3. 27..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class SmartCon_MyListCell: UITableViewCell {

    
    @IBOutlet weak var myCouponImageView: UIImageView!
    @IBOutlet weak var goodsTitleLabel: UILabel!
    @IBOutlet weak var goodsSubTitleLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var goodsPriceLabel: UILabel!
    @IBOutlet weak var exchangeStatusLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
