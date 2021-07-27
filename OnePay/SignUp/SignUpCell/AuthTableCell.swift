//
//  AuthTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Toaster

protocol AuthTableCellProtocol {
    func authTableCell(authTableCell : AuthTableCell)
}

// 회원가입 -> 본인인증 셀
class AuthTableCell:UITableViewCell {
    
    
    
    @IBOutlet weak var btn_PhoneAuth: UIButton!
    var delegate:AuthTableCellProtocol?
    
    override func awakeFromNib() {
        btn_PhoneAuth.layer.cornerRadius = 10
        super.awakeFromNib()
    }
    
    @IBAction func phoneAuthBtn(_ sender: UIButton) {
        let phoneAuthResult = Data_SignUp.shared.signUp_PhoneAuthResult
        
        if phoneAuthResult == "success" {
            Toast(text: "휴대폰 인증을 하셨습니다.").show()
            return
        } else {
            delegate?.authTableCell(authTableCell: self)
        }
    }
}



