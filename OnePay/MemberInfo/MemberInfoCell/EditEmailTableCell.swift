//
//  EditEmailTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditEmailTableCell: UITableViewCell {

    @IBOutlet weak var editEmailTableCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editEmailTableCellLabel.text = Data_MemberInfo.shared.user_email
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
