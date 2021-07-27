//
//  EmailTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Toaster

// 회원가입 -> 이메일주소 입력 셀
class EmailTableCell:UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var inputEmailTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellSetting()
        inputEmailTF.delegate = self
        inputEmailTF.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 기본 셀 셋팅
    func cellSetting(){
        inputEmailTF.attributedPlaceholder = NSAttributedString(string: "(ex) xxx@xxx.com",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        inputEmailTF.borderStyle = .none
        inputEmailTF.keyboardType = .emailAddress
        inputEmailTF.autocorrectionType = UITextAutocorrectionType.no
        inputEmailTF.spellCheckingType = UITextSpellCheckingType.no
        inputEmailTF.clearButtonMode = .whileEditing
    }
    
    @IBAction func strChanged(_ sender: Any) {
        let str = inputEmailTF?.text
        let emailCheck = isValidEmailAddress(email: str!)
        if emailCheck == true {
            Data_SignUp.shared.signUp_User_Email = str!
        } else {
            Data_SignUp.shared.signUp_User_Email = "fail"
        }
    }
    // 리턴키 눌렀을때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputEmailTF.resignFirstResponder()
        return true
    }
    
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @IBAction func editBegin(_ sender: Any) {
        Data_Default.shared.IndexPathNum = "up"

    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
}
