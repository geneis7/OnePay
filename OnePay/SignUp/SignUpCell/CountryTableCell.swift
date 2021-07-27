//
//  CountryTableCell.swift
//  BonoCard
///Users/youhaneul/iOS_Swift/iOS_Swift/BonoCard/BonoCard/SignUp/SignUpCell/CountryTableCell.swift
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol CountryTableCellProtocol{
    func countryName(countryName : CountryTableCell)
}

// 회원가입 -> 국적 선택 셀
class CountryTableCell:UITableViewCell,ChangeCountryLableProtocol {
    func changeCountryData(data: String) {
        
    }
    
    @IBOutlet weak var CountryTableCellTF: UITextField!
    @IBOutlet weak var btn_CountrySelect: UIButton!
    
    
    var delegate:CountryTableCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CountryTableCellTF.attributedPlaceholder = NSAttributedString(string: "국적선택",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        btn_CountrySelect.layer.cornerRadius = 10
        
        
        CountryTableCellTF.isEnabled = false
        CountryTableCellTF?.text = "대한민국"
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let user_nation = Data_SignUp.shared.signUp_User_Nation
        if user_nation != "" || user_nation == "대한민국" {
            CountryTableCellTF.text = user_nation
        } else {
            CountryTableCellTF.text = "대한민국"
            Data_SignUp.shared.signUp_User_Nation = "KR"
        }
    }

 
    @IBAction func countrySelectBtn(_ sender: Any) {
        
        self.delegate?.countryName(countryName: self)
    }
    
}

