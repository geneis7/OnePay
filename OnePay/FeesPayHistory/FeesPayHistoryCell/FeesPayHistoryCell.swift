//
//  FeesPayHistoryCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 16..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class FeesPayHistoryCell: UITableViewCell {

    @IBOutlet weak var feesPayHistoryCellDateLabel: UILabel!
    @IBOutlet weak var feesPayHistoryCellTypeLabel: UILabel!
    @IBOutlet weak var feesPayHistoryCellPointLabel: UILabel!
    @IBOutlet weak var feesPayHistoryCellUseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
