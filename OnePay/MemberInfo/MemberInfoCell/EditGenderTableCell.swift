//
//  EditGenderTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditGenderTableCell: UITableViewCell {

    @IBOutlet weak var editGenderTableCellLabel: UILabel!
    
    var gender:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if Data_MemberInfo.shared.user_gender == "M" {
            gender = "남성"
        } else if Data_MemberInfo.shared.user_gender == "F" {
            gender = "여성"
        } else {
            gender = ""
        }
        
        editGenderTableCellLabel.text = gender
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
