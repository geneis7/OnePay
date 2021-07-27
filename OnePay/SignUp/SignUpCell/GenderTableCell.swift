//
//  GenderTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit


// 회원가입 -> 성별 선택 셀
class GenderTableCell:UITableViewCell {
    
    @IBOutlet weak var genderSelectMaleBtn: UIButton!
    @IBOutlet weak var genderSelectFemaleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genderSelectMaleBtn.layer.cornerRadius = 10
        genderSelectFemaleBtn.layer.cornerRadius = 10
        genderSelectFemaleBtn.layer.borderWidth = 1
        genderSelectFemaleBtn.layer.borderColor = UIColor.init(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        genderSelectFemaleBtn.backgroundColor = UIColor.clear
        Data_SignUp.shared.signUp_User_Gender = "M"
        
    }
    
    @IBAction func genderSelectMaleBtn(_ sender: UIButton) {
        genderSelectMaleBtn.backgroundColor = UIColor.newColor_Brown
        genderSelectMaleBtn.setTitleColor(.white, for: .normal)
        genderSelectFemaleBtn.backgroundColor = .white
        Data_SignUp.shared.signUp_User_Gender = "M"
        
        genderSelectFemaleBtn.layer.borderWidth = 1
        genderSelectFemaleBtn.layer.borderColor = UIColor.init(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        genderSelectFemaleBtn.backgroundColor = UIColor.clear
        
        
    }
    @IBAction func genderSelectFemaleBtn(_ sender: UIButton) {
        
        genderSelectMaleBtn.layer.borderWidth = 1
        genderSelectMaleBtn.layer.borderColor = UIColor.init(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        genderSelectMaleBtn.backgroundColor = UIColor.clear
        
        genderSelectFemaleBtn.backgroundColor = UIColor.newColor_Brown
        genderSelectFemaleBtn.setTitleColor(.white, for: .normal)
        Data_SignUp.shared.signUp_User_Gender = "F"
    }
    
}


