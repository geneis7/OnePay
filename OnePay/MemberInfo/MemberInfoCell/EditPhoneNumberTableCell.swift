//
//  EditPhoneNumberTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditPhoneNumberTableCell: UITableViewCell {

    @IBOutlet weak var editPhoneNumberTableCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        editPhoneNumberTableCellLabel.text = Data_MemberInfo.shared.user_phone
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
