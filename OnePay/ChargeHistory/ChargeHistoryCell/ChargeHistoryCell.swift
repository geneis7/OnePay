//
//  ChargeHistoryCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 15..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ChargeHistoryCell: UITableViewCell {

    @IBOutlet weak var chargeHistoryCellDateLabel: UILabel!
    @IBOutlet weak var chargeHistoryCellPointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
