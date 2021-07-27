//
//  PaymentPasswordVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 9..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import KBNumberPad
import SCrypto

class PaymentPasswordVC: UIViewController,UITextFieldDelegate,KBNumberPadDelegate {
    
    @IBOutlet weak var paymentPasswordSlideBtnoutlet: UIButton!
    @IBOutlet weak var paymentPasswordStatusLabel: UILabel!
    @IBOutlet weak var inputPaymentPasswordOneTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordTwoTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordThreeTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordFourTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordFiveTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordSixTF: UITextField!
    @IBOutlet weak var paymentPasswordCompleteBtnOutlet: UIButton!
    
    let serviceUrl = UrlData()
    var passConfirmCheck = ""
    var paymentPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberPadSetting()
        textFieldSettings()
        
        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            
            self.paymentPasswordSlideBtnoutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    func textFieldSettings() {
        
        inputPaymentPasswordOneTF.becomeFirstResponder()
        inputPaymentPasswordOneTF.delegate = self
        inputPaymentPasswordOneTF.borderStyle = .none
        inputPaymentPasswordOneTF.keyboardType = .numberPad
        inputPaymentPasswordOneTF.clearButtonMode = .never
        inputPaymentPasswordOneTF.autocorrectionType = UITextAutocorrectionType.no
        inputPaymentPasswordOneTF.spellCheckingType = UITextSpellCheckingType.no
        
        inputPaymentPasswordTwoTF.delegate = self
        inputPaymentPasswordTwoTF.borderStyle = .none
        inputPaymentPasswordTwoTF.keyboardType = .numberPad
        inputPaymentPasswordTwoTF.clearButtonMode = .never
        inputPaymentPasswordTwoTF.autocorrectionType = UITextAutocorrectionType.no
        inputPaymentPasswordTwoTF.spellCheckingType = UITextSpellCheckingType.no
        
        inputPaymentPasswordThreeTF.delegate = self
        inputPaymentPasswordThreeTF.borderStyle = .none
        inputPaymentPasswordThreeTF.keyboardType = .numberPad
        inputPaymentPasswordThreeTF.clearButtonMode = .never
        inputPaymentPasswordThreeTF.autocorrectionType = UITextAutocorrectionType.no
        inputPaymentPasswordThreeTF.spellCheckingType = UITextSpellCheckingType.no
        
        inputPaymentPasswordFourTF.delegate = self
        inputPaymentPasswordFourTF.borderStyle = .none
        inputPaymentPasswordFourTF.keyboardType = .numberPad
        inputPaymentPasswordFourTF.clearButtonMode = .never
        inputPaymentPasswordFourTF.autocorrectionType = UITextAutocorrectionType.no
        inputPaymentPasswordFourTF.spellCheckingType = UITextSpellCheckingType.no
        
        inputPaymentPasswordFiveTF.delegate = self
        inputPaymentPasswordFiveTF.borderStyle = .none
        inputPaymentPasswordFiveTF.keyboardType = .numberPad
        inputPaymentPasswordFiveTF.clearButtonMode = .never
        inputPaymentPasswordFiveTF.autocorrectionType = UITextAutocorrectionType.no
        inputPaymentPasswordFiveTF.spellCheckingType = UITextSpellCheckingType.no
        
        inputPaymentPasswordSixTF.delegate = self
        inputPaymentPasswordSixTF.borderStyle = .none
        inputPaymentPasswordSixTF.keyboardType = .numberPad
        inputPaymentPasswordSixTF.clearButtonMode = .never
        inputPaymentPasswordSixTF.autocorrectionType = UITextAutocorrectionType.no
        inputPaymentPasswordSixTF.spellCheckingType = UITextSpellCheckingType.no
        
        
        
        // 텍스트 필드 밑줄
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: inputPaymentPasswordOneTF.frame.size.height - width, width:  inputPaymentPasswordOneTF.frame.size.width, height: inputPaymentPasswordOneTF.frame.size.height)
        border.borderWidth = width
        inputPaymentPasswordOneTF.layer.addSublayer(border)
        inputPaymentPasswordOneTF.layer.masksToBounds = true
        
        let border2 = CALayer()
        let width2 = CGFloat(1.0)
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: inputPaymentPasswordTwoTF.frame.size.height - width2, width:  inputPaymentPasswordTwoTF.frame.size.width, height: inputPaymentPasswordTwoTF.frame.size.height)
        border2.borderWidth = width2
        inputPaymentPasswordTwoTF.layer.addSublayer(border2)
        inputPaymentPasswordTwoTF.layer.masksToBounds = true
        
        let border3 = CALayer()
        let width3 = CGFloat(1.0)
        border3.borderColor = UIColor.white.cgColor
        border3.frame = CGRect(x: 0, y: inputPaymentPasswordThreeTF.frame.size.height - width3, width:  inputPaymentPasswordThreeTF.frame.size.width, height: inputPaymentPasswordThreeTF.frame.size.height)
        border3.borderWidth = width2
        inputPaymentPasswordThreeTF.layer.addSublayer(border3)
        inputPaymentPasswordThreeTF.layer.masksToBounds = true
        
        let border4 = CALayer()
        let width4 = CGFloat(1.0)
        border4.borderColor = UIColor.white.cgColor
        border4.frame = CGRect(x: 0, y: inputPaymentPasswordFourTF.frame.size.height - width4, width:  inputPaymentPasswordFourTF.frame.size.width, height: inputPaymentPasswordFourTF.frame.size.height)
        border4.borderWidth = width4
        inputPaymentPasswordFourTF.layer.addSublayer(border4)
        inputPaymentPasswordFourTF.layer.masksToBounds = true
        
        let border5 = CALayer()
        let width5 = CGFloat(1.0)
        border5.borderColor = UIColor.white.cgColor
        border5.frame = CGRect(x: 0, y: inputPaymentPasswordFiveTF.frame.size.height - width5, width:  inputPaymentPasswordFiveTF.frame.size.width, height: inputPaymentPasswordFiveTF.frame.size.height)
        border5.borderWidth = width5
        inputPaymentPasswordFiveTF.layer.addSublayer(border5)
        inputPaymentPasswordFiveTF.layer.masksToBounds = true
        
        let border6 = CALayer()
        let width6 = CGFloat(1.0)
        border6.borderColor = UIColor.white.cgColor
        border6.frame = CGRect(x: 0, y: inputPaymentPasswordSixTF.frame.size.height - width6, width:  inputPaymentPasswordSixTF.frame.size.width, height: inputPaymentPasswordSixTF.frame.size.height)
        border6.borderWidth = width6
        inputPaymentPasswordSixTF.layer.addSublayer(border6)
        inputPaymentPasswordSixTF.layer.masksToBounds = true
        
        
        
        
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("shouldChange++++")
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        let newLengthTotalCount_1 = (inputPaymentPasswordOneTF.text?.count)!
            + (inputPaymentPasswordTwoTF.text?.count)!
            + (inputPaymentPasswordThreeTF.text?.count)!
        let newLengthTotalCount_2 = (inputPaymentPasswordFourTF.text?.count)!
            + (inputPaymentPasswordFiveTF.text?.count)!
            + (inputPaymentPasswordFiveTF.text?.count)!
        let newLengthTotalCount:Int = newLengthTotalCount_1 + newLengthTotalCount_2
        
        if newLengthTotalCount <= 6 {
            if (inputPaymentPasswordOneTF.text?.count == 1)
                && ((inputPaymentPasswordTwoTF.text?.count)! != 1){
                inputPaymentPasswordTwoTF.becomeFirstResponder()
                return newLength < 3
            } else if (inputPaymentPasswordOneTF.text?.count == 1)
                && (inputPaymentPasswordTwoTF.text?.count == 1)
                && ((inputPaymentPasswordThreeTF.text?.count)! != 1){
                inputPaymentPasswordThreeTF.becomeFirstResponder()
                return newLength < 3
            } else if (inputPaymentPasswordOneTF.text?.count == 1)
                && (inputPaymentPasswordTwoTF.text?.count == 1)
                && (inputPaymentPasswordThreeTF.text?.count == 1)
                && ((inputPaymentPasswordFourTF.text?.count)! != 1){
                inputPaymentPasswordFourTF.becomeFirstResponder()
                return newLength < 3
            } else if (inputPaymentPasswordOneTF.text?.count == 1)
                && (inputPaymentPasswordTwoTF.text?.count == 1)
                && (inputPaymentPasswordThreeTF.text?.count == 1)
                && (inputPaymentPasswordFourTF.text?.count == 1)
                && ((inputPaymentPasswordFiveTF.text?.count)! != 1){
                inputPaymentPasswordFiveTF.becomeFirstResponder()
                return newLength < 3
            } else if (inputPaymentPasswordOneTF.text?.count == 1)
                && (inputPaymentPasswordTwoTF.text?.count == 1)
                && (inputPaymentPasswordThreeTF.text?.count == 1)
                && (inputPaymentPasswordFourTF.text?.count == 1)
                && (inputPaymentPasswordFiveTF.text?.count == 1)
                && ((inputPaymentPasswordSixTF.text?.count)! != 1){
                inputPaymentPasswordSixTF.becomeFirstResponder()
                return newLength < 3
            } else if (inputPaymentPasswordOneTF.text?.count == 1)
                && (inputPaymentPasswordTwoTF.text?.count == 1)
                && (inputPaymentPasswordThreeTF.text?.count == 1)
                && (inputPaymentPasswordFourTF.text?.count == 1)
                && (inputPaymentPasswordFiveTF.text?.count == 1)
                && (inputPaymentPasswordSixTF.text?.count == 1) {
                view.endEditing(true)
            }
        }
        return newLength < 2
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("DidBeginEditing++++")
    }
   
    func numberPadSetting(){
        let numberPad = KBNumberPad()
        
        inputPaymentPasswordOneTF.inputView = numberPad
        inputPaymentPasswordTwoTF.inputView = numberPad
        inputPaymentPasswordThreeTF.inputView = numberPad
        inputPaymentPasswordFourTF.inputView = numberPad
        inputPaymentPasswordFiveTF.inputView = numberPad
        inputPaymentPasswordSixTF.inputView = numberPad
        
        numberPad.setDelimiterColor(UIColor.lightGray)
        numberPad.setButtonsColor(UIColor.darkGray)
        numberPad.setButtonsBackgroundColor(UIColor.white)
        
        numberPad.setNumberButtonsColor(UIColor.black)
        numberPad.setClearButtonColor(UIColor.darkGray)
        numberPad.setDoneButtonColor(UIColor.darkGray)
        numberPad.setClearButtonImage(#imageLiteral(resourceName: "sidemenu_backup.png"))
        numberPad.setDoneButtonTitle("Clear")
        
        numberPad.delegate = self
    }
    
    func onNumberClicked(numberPad: KBNumberPad, number: Int) {
        print("************************************************")
        paymentPassword = paymentPassword + "\(number)"
        print("newtext")
        print(paymentPassword)
        
        if inputPaymentPasswordOneTF.text == ""
        {
            inputPaymentPasswordOneTF.text = "\(number)"
            inputPaymentPasswordTwoTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text == "")
        {
            inputPaymentPasswordTwoTF.text = "\(number)"
            inputPaymentPasswordTwoTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text == "")
        {
            inputPaymentPasswordThreeTF.text = "\(number)"
            inputPaymentPasswordThreeTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text != "") &&
            (inputPaymentPasswordFourTF.text == "")
        {
            inputPaymentPasswordFourTF.text = "\(number)"
            inputPaymentPasswordFourTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text != "") &&
            (inputPaymentPasswordFourTF.text != "") &&
            (inputPaymentPasswordFiveTF.text == "")
        {
            inputPaymentPasswordFiveTF.text = "\(number)"
            inputPaymentPasswordFiveTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text != "") &&
            (inputPaymentPasswordFourTF.text != "") &&
            (inputPaymentPasswordFiveTF.text != "") &&
            (inputPaymentPasswordSixTF.text == "")
        {
            inputPaymentPasswordSixTF.text = "\(number)"
            inputPaymentPasswordSixTF.becomeFirstResponder()
            
            if paymentPassword.count == 6 {
                if passConfirmCheck == ""{
                    passConfirmCheck = paymentPassword
                    paymentPassword = ""
                    inputPaymentPasswordOneTF.text = ""
                    inputPaymentPasswordTwoTF.text = ""
                    inputPaymentPasswordThreeTF.text = ""
                    inputPaymentPasswordFourTF.text = ""
                    inputPaymentPasswordFiveTF.text = ""
                    inputPaymentPasswordSixTF.text = ""
                    inputPaymentPasswordOneTF.becomeFirstResponder()
                    paymentPasswordStatusLabel.text = "한번 더 입력해 주세요."
                } else if passConfirmCheck != paymentPassword {
                    displayMsg(title: "원페이", msg: "비밀번호를 다시 입력해주세요.")
                    paymentPassword = ""
                    passConfirmCheck = ""
                    inputPaymentPasswordOneTF.text = ""
                    inputPaymentPasswordTwoTF.text = ""
                    inputPaymentPasswordThreeTF.text = ""
                    inputPaymentPasswordFourTF.text = ""
                    inputPaymentPasswordFiveTF.text = ""
                    inputPaymentPasswordSixTF.text = ""
                    inputPaymentPasswordOneTF.becomeFirstResponder()
                    paymentPasswordStatusLabel.text = "결제용 비밀번호를 입력해주세요."
                    
                } else if passConfirmCheck == paymentPassword  {
                    Data_PaymentPassword.shared.regist_PaymentPassword = paymentPassword
                    registAccountComplete()
                }
            }
        }
    }
    
    func onDoneClicked(numberPad: KBNumberPad) {
        NSLog("Done clicked")
    }
    
    func onClearClicked(numberPad: KBNumberPad) {
        
        let str_drop_last = paymentPassword.dropLast()
        paymentPassword = String(str_drop_last)
        print("str_drop_last")
        print(str_drop_last)
        
        if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text != "") &&
            (inputPaymentPasswordFourTF.text != "") &&
            (inputPaymentPasswordFiveTF.text != "") &&
            (inputPaymentPasswordSixTF.text != "")
        {
            inputPaymentPasswordSixTF.text = ""
            inputPaymentPasswordSixTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text != "") &&
            (inputPaymentPasswordFourTF.text != "") &&
            (inputPaymentPasswordFiveTF.text != "") &&
            (inputPaymentPasswordSixTF.text == "")
        {
            inputPaymentPasswordFiveTF.text = ""
            inputPaymentPasswordFiveTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text != "") &&
            (inputPaymentPasswordFourTF.text != "") &&
            (inputPaymentPasswordFiveTF.text == "") &&
            (inputPaymentPasswordSixTF.text == "")
        {
            inputPaymentPasswordFourTF.text = ""
            inputPaymentPasswordFourTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text != "") &&
            (inputPaymentPasswordFourTF.text == "") &&
            (inputPaymentPasswordFiveTF.text == "") &&
            (inputPaymentPasswordSixTF.text == "")
        {
            inputPaymentPasswordThreeTF.text = ""
            inputPaymentPasswordThreeTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text != "") &&
            (inputPaymentPasswordThreeTF.text == "") &&
            (inputPaymentPasswordFourTF.text == "") &&
            (inputPaymentPasswordFiveTF.text == "") &&
            (inputPaymentPasswordSixTF.text == "")
        {
            inputPaymentPasswordTwoTF.text = ""
            inputPaymentPasswordTwoTF.becomeFirstResponder()
        }
            
        else if (inputPaymentPasswordOneTF.text != "") &&
            (inputPaymentPasswordTwoTF.text == "") &&
            (inputPaymentPasswordThreeTF.text == "") &&
            (inputPaymentPasswordFourTF.text == "") &&
            (inputPaymentPasswordFiveTF.text == "") &&
            (inputPaymentPasswordSixTF.text == "")
        {
            inputPaymentPasswordOneTF.text = ""
            inputPaymentPasswordOneTF.becomeFirstResponder()
        }
    }
    
    func alert() {
        let title = "원페이"
        let message = "계좌 등록이 완료 되었습니다."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default) {
            UIAlertAction in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccountHave")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func registAccountComplete(){
        let member_srl = Data_MemberInfo.shared.member_srl
        let bank_code = Data_BankInfo.shared.selectBankCode
        let pay_password = Data_PaymentPassword.shared.regist_PaymentPassword.SHA256()
        
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/registAccount"
            let param: Parameters = [
                "member_srl": member_srl,
                "bank_code": bank_code,
                "pay_password": pay_password
            ]

            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        print("//---------->    가상계좌 등록 성공    <----------//")
                        self.alert()
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        print("//---------->    가상계좌 등록 실패    <----------//")
                        self.displayMsg(title: "원페이 \n", msg: "잠시 후 다시 등록해주세요.")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
}
