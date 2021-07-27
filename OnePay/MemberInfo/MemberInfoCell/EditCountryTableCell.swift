//
//  EditCountryTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditCountryTableCell: UITableViewCell {

    
    @IBOutlet weak var editCountryTableCellLabel: UILabel!
    let countryNameList = CountryList.countryList.keys
    let countryCodeList = CountryList.countryList.values

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nationName = Data_MemberInfo.shared.user_nation
        let nationCodeArray = Array(countryNameList)
        let nationNameArray = Array(countryCodeList)

        var dic:[String:String] = [:]
        
        var cnt = 0
        while cnt != nationCodeArray.count {
            dic.updateValue(nationCodeArray[cnt], forKey: nationNameArray[cnt])
            cnt = cnt + 1
        }

        let tranDic = dic["\(nationName)"]!
        
            editCountryTableCellLabel.text = tranDic
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
