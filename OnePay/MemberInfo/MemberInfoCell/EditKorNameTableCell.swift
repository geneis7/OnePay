//
//  EditKorNameTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditKorNameTableCell: UITableViewCell {

    @IBOutlet weak var editKorNameTableCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editKorNameTableCellLabel.text = Data_MemberInfo.shared.user_name
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
