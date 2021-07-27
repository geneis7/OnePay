//
//  EditDateOfBirthTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditDateOfBirthTableCell: UITableViewCell {

    @IBOutlet weak var editDateOfBirthTableCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        editDateOfBirthTableCellLabel.text = Data_MemberInfo.shared.user_birth
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
