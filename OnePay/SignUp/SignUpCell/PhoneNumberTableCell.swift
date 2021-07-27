//
//  PhoneNumberTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import KBNumberPad


protocol PhoneNumberTableCellProtocol {
    func phoneNumberCheck(phoneNumberCheck:PhoneNumberTableCell)
}


// 회원가입 -> 휴대폰번호 입력 셀
class PhoneNumberTableCell:UITableViewCell,UITextFieldDelegate , KBNumberPadDelegate{

    
    
    @IBOutlet weak var inputPhoneNumberTF: UITextField!
    @IBOutlet weak var btn_PhoneNumCheck: UIButton!
    
    var delegate:PhoneNumberTableCellProtocol?
    var inputPhoneNum:String = ""
    let vc = SignUpVC()
    let serviceUrl = UrlData()
    var phoneAuthEndAfterChange:String = ""
    var phoneNum:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cellSetting()
        inputPhoneNumberTF.delegate = self
        inputPhoneNumberTF.text = ""
        numberPadSetting()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func numberPadSetting(){
        let numberPad = KBNumberPad()
        let str = "clear"
        
        inputPhoneNumberTF.inputView = numberPad
        
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
    
    func onNumberClicked(numberPad: KBNumberPad, number: Int) {
        
        guard let textLength = inputPhoneNumberTF?.text?.count else { return }
        if Int(textLength) > 14 {
            return
        }   
        
        phoneNum = phoneNum + "\(number)"
        inputPhoneNumberTF.text = phoneNum
        
        let str = inputPhoneNumberTF?.text
        if phoneAuthEndAfterChange == "success" {
            let phoneNum = Data_SignUp.shared.signUp_User_PhoneNumber
            if phoneNum != str {
                Data_SignUp.shared.signUp_User_PhoneNumber_Result = "fail"
                Data_SignUp.shared.signUp_User_PhoneNumber = ""
                phoneAuthEndAfterChange = "fail"
            }
        }
        Data_SignUp.shared.signUp_User_PhoneNumber = str!
        print("\(Data_SignUp.shared.signUp_User_PhoneNumber)")
        
        
    }
    
    func onDoneClicked(numberPad: KBNumberPad) {
        
        inputPhoneNumberTF.resignFirstResponder()
    }
    
    func onClearClicked(numberPad: KBNumberPad) {
        let str_drop_last = phoneNum.dropLast()
        phoneNum = String(str_drop_last)
        inputPhoneNumberTF.text = phoneNum
    }

    @IBAction func phoneNumberDoubleCheckBtn(_ sender: UIButton) {
        
        let user_phone = self.phoneNum
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/phoneCheck"
            let param: Parameters = [
                "user_phone": user_phone,
                ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        print("휴대폰 번호 등록 가능!!")

                        Data_SignUp.shared.signUp_User_PhoneNumber_Result = "success"
                        Data_SignUp.shared.signUp_User_PhoneNumber = self.phoneNum

                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        print("휴대폰 등록 불가능!!")
                        Data_SignUp.shared.signUp_User_PhoneNumber_Result = "fail"
                        Data_SignUp.shared.signUp_User_PhoneNumber = ""
                        self.phoneAuthEndAfterChange = "success"

                    } else {
                        print("등록실패")
                        Data_SignUp.shared.signUp_User_PhoneNumber_Result = "fail"
                        Data_SignUp.shared.signUp_User_PhoneNumber = ""

                    }
                    
                    self.delegate?.phoneNumberCheck(phoneNumberCheck: self)
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
                
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        phoneNum = ""
        inputPhoneNumberTF?.text = ""
        
        return true
    }
    
    // 텍스트 필드 수정 끝날때 호출
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (inputPhoneNumberTF.text?.isEmpty)!{
            configureAppearance()
        }
        return true
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
        inputPhoneNumberTF.layer.cornerRadius = 10
        inputPhoneNumberTF.attributedPlaceholder = NSAttributedString(string: "숫자만 입력(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        inputPhoneNumberTF.borderStyle = .none
//        inputPhoneNumberTF.keyboardType = .numberPad
        inputPhoneNumberTF.autocorrectionType = UITextAutocorrectionType.no
        inputPhoneNumberTF.spellCheckingType = UITextSpellCheckingType.no
        inputPhoneNumberTF.clearButtonMode = .never
    }
    
    @IBAction func editBegin(_ sender: Any) {
        Data_Default.shared.IndexPathNum = "numpad"
    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""

    }
    

    
}


