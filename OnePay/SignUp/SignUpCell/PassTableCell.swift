//
//  PassTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import SCrypto

// 회원가입 -> 비밀번호 입력 셀
class PassTableCell:UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var inputPassTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputPassTF.attributedPlaceholder = NSAttributedString(string: "6-15 자리, 영문+숫자 조합",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        cellSetting()
        inputPassTF.delegate = self
        inputPassTF.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 알림 메세지 커스텀
    func configureAppearance() {
        let appearance = ToastView.appearance()
        appearance.backgroundColor = .lightGray
        appearance.textColor = .black
        appearance.font = .boldSystemFont(ofSize: 20)
        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        appearance.bottomOffsetPortrait = 100
        appearance.cornerRadius = 20
    }
    
    // 기본 셀 셋팅
    func cellSetting(){
        inputPassTF.borderStyle = .none
        inputPassTF.keyboardType = .asciiCapable
        inputPassTF.clearButtonMode = .whileEditing
        inputPassTF.autocorrectionType = UITextAutocorrectionType.no
        inputPassTF.spellCheckingType = UITextSpellCheckingType.no
        inputPassTF.isSecureTextEntry = true
    }
    
    // 텍스트 필듸의 내용이 변경될 때 입력 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length

        return newLength <= 15
    }

    
    
    

    @IBAction func strChanged(_ sender: Any) {
        guard let text = inputPassTF?.text else { return}

        let passCheck1 = String(checkPass(text))
        let passCheck2 = String(checkPass2(text))
        
        Data_SignUp.shared.signUp_PassCheck1 = passCheck1
        Data_SignUp.shared.signUp_PassCheck2 = passCheck2
        
        let sha256encryption = text.SHA256()
        Data_SignUp.shared.signUp_Password = sha256encryption

    }
    
    
    // 리턴키 눌렀을때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputPassTF.resignFirstResponder()
        return true
    }

    func checkPass(_ pw: String) -> Bool {
        let check = "^(?=.*[a-zA-Z])(?=.*[0-9]).{6,15}$"
        let match: NSRange = (pw as NSString).range(of: check, options: .regularExpression)
        if NSNotFound == match.location {
            return false
        }
        return true
    }
    
    func checkPass2(_ pw: String) -> Bool {
        let check = "^(?=.*[!@#$&*])"
        let match: NSRange = (pw as NSString).range(of: check, options: .regularExpression)
        if NSNotFound == match.location {
            return false
        }
        return true
    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
}
