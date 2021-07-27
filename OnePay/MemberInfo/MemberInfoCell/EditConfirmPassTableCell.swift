//
//  EditConfirmPassTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditConfirmPassTableCell: UITableViewCell,UITextFieldDelegate{

    @IBOutlet weak var inputEditConfirmPassTableCellTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
            cellSetting()
        inputEditConfirmPassTableCellTF.text = ""
        inputEditConfirmPassTableCellTF.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // 기본 셀 셋팅
    func cellSetting(){
        inputEditConfirmPassTableCellTF.borderStyle = .none
        inputEditConfirmPassTableCellTF.keyboardType = .asciiCapable
        inputEditConfirmPassTableCellTF.clearButtonMode = .whileEditing
        inputEditConfirmPassTableCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputEditConfirmPassTableCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputEditConfirmPassTableCellTF.isSecureTextEntry =  true
        inputEditConfirmPassTableCellTF.attributedPlaceholder = NSAttributedString(string: "6-15 자리, 영문+숫자 조합",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputEditConfirmPassTableCellTF.resignFirstResponder()
        return true
    }
    
    // 텍스트 필듸의 내용이 변경될 때 입력 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        return newLength <= 15
    }
    
    // 텍스트 필드 입력 종료 될때 필드 값 전송
    @IBAction func strChanged(_ sender: Any) {
        guard let text = inputEditConfirmPassTableCellTF.text else { return }
        if text.isEmpty {
            print("비어있음")
        }
        
        let confirmPassCheck1 = String(checkPass(text))
        let confirmPassCheck2 = String(checkPass2(text))
        
        Data_MemberInfo_Edit.shared.edit_Confirm_PassCheck1 = confirmPassCheck1
        Data_MemberInfo_Edit.shared.edit_Confirm_PassCheck2 = confirmPassCheck2
        
        let sha256encryption = text.SHA256()
        Data_MemberInfo_Edit.shared.edit_Confirm_password = sha256encryption
        
        if text.count == 0 {
            Data_MemberInfo_Edit.shared.edit_Confirm_PassCheck1 = ""
            Data_MemberInfo_Edit.shared.edit_Confirm_PassCheck2 = ""
            Data_MemberInfo_Edit.shared.edit_Confirm_password = ""
        }
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
    
}
