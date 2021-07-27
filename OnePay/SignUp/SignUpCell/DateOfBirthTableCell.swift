//
//  DateOfBirthTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import KBNumberPad

protocol DateOfBirthTableCellProtocol {
    func dateOfBirth(dateOfBirth : DateOfBirthTableCell)
}

// 회원가입 -> 생년월일 입력 셀
class DateOfBirthTableCell:UITableViewCell,UITextFieldDelegate,KBNumberPadDelegate {

    
    
    @IBOutlet weak var inputDateOfBirthTF: UITextField!
    
    var delegate:DateOfBirthTableCellProtocol?
    var user_birth:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputDateOfBirthTF.attributedPlaceholder = NSAttributedString(string: "6자리. (ex)800101",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        numberPadSetting()
        configureAppearance()
        cellSetting()
        inputDateOfBirthTF.delegate = self
        inputDateOfBirthTF.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func strChanged(_ sender: Any) {
        let str = inputDateOfBirthTF?.text
        Data_SignUp.shared.signUp_User_Birth = str!
    }

    func onNumberClicked(numberPad: KBNumberPad, number: Int) {
        guard let textLength = inputDateOfBirthTF?.text?.count else { return }
        if Int(textLength) > 5 {
            return
        }
        user_birth = user_birth + "\(number)"
        Data_SignUp.shared.signUp_User_Birth = user_birth
        inputDateOfBirthTF.text = user_birth
    }
    
    func onDoneClicked(numberPad: KBNumberPad) {
        inputDateOfBirthTF.resignFirstResponder()
    }
    
    func onClearClicked(numberPad: KBNumberPad) {
        let str_drop_last = user_birth.dropLast()
        user_birth = String(str_drop_last)
        inputDateOfBirthTF.text = user_birth
    }
    
    func numberPadSetting(){
        let numberPad = KBNumberPad()
        let str = "clear"
        
        inputDateOfBirthTF.inputView = numberPad
        
        numberPad.setDelimiterColor(UIColor.lightGray)
        numberPad.setButtonsColor(UIColor.darkGray)
        numberPad.setButtonsBackgroundColor(UIColor.white)
        
        numberPad.setNumberButtonsColor(UIColor.black)
        numberPad.setClearButtonColor(UIColor.darkGray)
        numberPad.setDoneButtonColor(UIColor.darkGray)
        numberPad.setClearButtonImage(#imageLiteral(resourceName: "asterisk"))
        numberPad.setDoneButtonTitle(str)
        
        numberPad.delegate = self
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
        inputDateOfBirthTF.borderStyle = .none
//        inputDateOfBirthTF.keyboardType = .numberPad
        inputDateOfBirthTF.autocorrectionType = UITextAutocorrectionType.no
        inputDateOfBirthTF.spellCheckingType = UITextSpellCheckingType.no
        inputDateOfBirthTF.clearButtonMode = .whileEditing
    }
    
    // 텍스트 필듸의 내용이 변경될 때 호출 + 입력 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if newLength == 7 {
            endEditing(true)
        }
        return newLength <= 6
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        user_birth = ""
        inputDateOfBirthTF?.text = ""
        return true
    }
    
    @IBAction func editBegin(_ sender: Any) {
        Data_Default.shared.IndexPathNum = "numpad"
    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
}



