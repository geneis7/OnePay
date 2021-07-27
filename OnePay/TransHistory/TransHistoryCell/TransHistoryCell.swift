//
//  TransHistoryCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class TransHistoryCell: UITableViewCell {

    @IBOutlet weak var transHistoryCellDateLabel: UILabel!
    @IBOutlet weak var transHistoryCellPointLabel: UILabel!
    @IBOutlet weak var transHistoryCellDumLabel: UILabel!
    @IBOutlet weak var transHistoryCellPayTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
