//
//  EditEngNameTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditEngNameTableCell: UITableViewCell {

    @IBOutlet weak var editEngNameTableCellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            editEngNameTableCellLabel.text = Data_MemberInfo.shared.eng_name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
