//
//  ShopApplyDivisionCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ShopApplyDivisionCell: UITableViewCell {
    
    @IBOutlet weak var shopApplyDivisionOffBtnOutlet: UIButton!
    @IBOutlet weak var shopApplyDivisionOnBtnOutlet: UIButton!
    var shopDivision = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSetting()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
        // Configure the view for the selected state
    }
    
    func defaultSetting(){
        shopApplyDivisionOffBtnOutlet.backgroundColor = UIColor.lightGray
        shopApplyDivisionOffBtnOutlet.layer.borderColor = UIColor.init(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        shopApplyDivisionOffBtnOutlet.layer.borderWidth = 1
        shopApplyDivisionOffBtnOutlet.layer.cornerRadius = 10
        
        
        
        
        
        
        shopApplyDivisionOnBtnOutlet.backgroundColor = UIColor.newColor_Blue
        shopApplyDivisionOnBtnOutlet.layer.cornerRadius = 10
        shopApplyDivisionOnBtnOutlet.layer.borderColor = UIColor.init(red:44/255.0, green:100/255.0, blue:152/255.0, alpha: 1.0).cgColor
        
        shopDivision = "Y"
        Data_ShopApply.shared.shopApply_Division = shopDivision
    }
    
    @IBAction func shopApplyDivisionOffBtn(_ sender: Any) {
        shopApplyDivisionOnBtnOutlet.backgroundColor = UIColor.lightGray
        shopApplyDivisionOnBtnOutlet.layer.borderColor = UIColor.init(red:44/255.0, green:100/255.0, blue:152/255.0, alpha: 1.0).cgColor
        shopApplyDivisionOnBtnOutlet.layer.borderWidth = 1
        shopApplyDivisionOnBtnOutlet.layer.cornerRadius = 10
        
        
        
        
        shopApplyDivisionOnBtnOutlet.layer.borderColor = UIColor.init(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        
        shopApplyDivisionOffBtnOutlet.backgroundColor = UIColor.newColor_Blue
        shopApplyDivisionOffBtnOutlet.layer.cornerRadius = 10
        
        
        shopDivision = "N"
        Data_ShopApply.shared.shopApply_Division = shopDivision
        
    }
    
    @IBAction func shopApplyDivisionOnBtn(_ sender: Any) {
        shopApplyDivisionOffBtnOutlet.backgroundColor = UIColor.lightGray
        shopApplyDivisionOffBtnOutlet.layer.borderColor = UIColor.init(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        shopApplyDivisionOffBtnOutlet.layer.borderWidth = 1
        shopApplyDivisionOffBtnOutlet.layer.cornerRadius = 10


        
        
        
        
        shopApplyDivisionOnBtnOutlet.layer.borderColor = UIColor.init(red:44/255.0, green:100/255.0, blue:152/255.0, alpha: 1.0).cgColor
        shopApplyDivisionOnBtnOutlet.backgroundColor = UIColor.newColor_Blue
        shopApplyDivisionOnBtnOutlet.layer.cornerRadius = 10
        
        
        shopDivision = "Y"
        Data_ShopApply.shared.shopApply_Division = shopDivision
    }
    
}
