//
//  SendMoneyPaymentPasswordVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 23..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import KBNumberPad
import SCrypto

class SendMoneyPaymentPasswordVC: UIViewController,UITextFieldDelegate,KBNumberPadDelegate {
    
    @IBOutlet weak var inputPaymentPasswordOneTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordTwoTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordThreeTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordFourTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordFiveTF: UITextField!
    @IBOutlet weak var inputPaymentPasswordSixTF: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    let serviceUrl = UrlData()
    
    var paymentPassword = ""
    var member_srl:String = ""
    var totalAmount:String  = ""
    var cashAmount:String  = ""
    var outName:String  = ""
    var inBankCode:String  = ""
    var inBankCode2:String  = ""
    var inAccNo:String  = ""
    var uniqueTime:String = ""
    var apprvNum:String = ""
    
    // 나의쿠폰 취소 요청 영역
    var myCouponCancelData:JSON = JSON.init(rawValue: [])!
    var myCon_Vali_Detail_Data:[String] = []
    
    // 스마트콘 영역
    var select_Brand_goods:[String] = []
    
    // 스마트콘 - 나의쿠폰 영역
    var myConListData:JSON = JSON.init(rawValue: [])!
    var myCon_tr_id:[String] = []
    var myCon_member_srl:[String] = []
    var myCon_event_id:[String] = []
    var myCon_goods_id:[String] = []
    var myCon_disc_price:[String] = []
    var myCon_disc_rate:[String] = []
    var myCon_price:[String] = []
    var myCon_order_cnt:[String] = []
    var myCon_img_url:[String] = []
    var myCon_exchange_status:[String] = []
    var myCon_goods_name:[String] = []
    var myCon_brand_name:[String] = []
    
    // 스마트콘 - 실시간 교환상태 영역
    var myConList_ValiData:JSON = JSON.init(rawValue: [])!
    var myCon_Vali_claim_type:[String] = []
    var myCon_Vali_valid_start:[String] = []
    var myCon_Vali_valid_end:[String] = []
    var myCon_Vali_tr_id:[String] = []
    var myCon_Vali_exchange_date:[String] = []
    var myCon_Vali_order_date:[String] = []
    var myCon_Vali_exchange_status:[String] = []
    var myCon_Vali_cancel_period:[String] = []
    var myCon_Vali_cancelable:[String] = []
    var tr_id_loop_cnt:Int = 0
    var cnt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        tranInsertDataLoad()
        textFieldSettings()
        numberPadSetting()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 텍스트 필드 기본 셋팅
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
    
    // 텍스트 필드 내용이 변경 될때 실행
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str1 = (inputPaymentPasswordOneTF.text)!
            + (inputPaymentPasswordTwoTF.text)!
            + (inputPaymentPasswordThreeTF.text)!
        let str2 = (inputPaymentPasswordFourTF.text)!
        + (inputPaymentPasswordFiveTF.text)!
        + (inputPaymentPasswordSixTF.text)!
        let payPasswordTotal = str1 + str2
            
            
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        let newLengthTotalCount_1:Int = (inputPaymentPasswordOneTF.text?.count)!
            + (inputPaymentPasswordTwoTF.text?.count)!
            + (inputPaymentPasswordThreeTF.text?.count)!
        let newLengthTotalCount_2:Int = (inputPaymentPasswordFourTF.text?.count)!
            + (inputPaymentPasswordFiveTF.text?.count)!
            + (inputPaymentPasswordSixTF.text?.count)!
        let newLengthTotalCount:Int = newLengthTotalCount_1 + newLengthTotalCount_2
        
        if newLengthTotalCount == 5 {
            print("payPasswordTotal *********************")
            print(payPasswordTotal)
        }
        
        
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
        let str1 = (inputPaymentPasswordOneTF.text)!
            + (inputPaymentPasswordTwoTF.text)!
            + (inputPaymentPasswordThreeTF.text)!
        let str2 = (inputPaymentPasswordFourTF.text)!
            + (inputPaymentPasswordFiveTF.text)!
            + (inputPaymentPasswordSixTF.text)!
        let payPasswordTotal = str1 + str2
            
        
        if payPasswordTotal.count == 6 {
        }
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
    
    // 결제 비밀번호 입력 이벤트
    func onNumberClicked(numberPad: KBNumberPad, number: Int) {
        paymentPassword = paymentPassword + "\(number)"
        
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
                
                let pay_password = Data_MemberInfo.shared.pay_password
                
                let sha256 = paymentPassword.SHA256()
                
                // 서버에서 가져온 결제 비번 과 입력한 결제 비번이 서로 같을때 결제비번 종류 분기
                if pay_password == sha256 {
                    
                    let sendMoneyCheck = Data_SendMoney.shared.sendMoney_Flag
                    
                    switch sendMoneyCheck {
                    case "sendMoney" : sendMoneyInfoDataSend()
                        
                    case "feesPay" : feesPayDataSend()
                        
                    case "qrPay" : qrPayDataSend()
                        
                    case "smartConPay" : smartConBuyDataSend()
                        
                    case "myCouponCancel" : myCouponCancelDataSend()
                        
                    default : return
                    }
                    
                } else {
                    
                    
                    
                    displayMsg(title: "원페이 \n", msg: "비밀번호가 일치하지 않습니다.\n다시 입력해 주세요.")
                    paymentPassword = ""
                    inputPaymentPasswordOneTF.text = ""
                    inputPaymentPasswordTwoTF.text = ""
                    inputPaymentPasswordThreeTF.text = ""
                    inputPaymentPasswordFourTF.text = ""
                    inputPaymentPasswordFiveTF.text = ""
                    inputPaymentPasswordSixTF.text = ""
                    inputPaymentPasswordOneTF.becomeFirstResponder()
                }
            }
        }
        
        
        
    }
    
    // 넘버패드 Done 키 이벤트
    func onDoneClicked(numberPad: KBNumberPad) {
        NSLog("Done clicked")
        //        testTF.resignFirstResponder()
    }
    
    // 넘버패드 Clear 키 이벤트
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
    
    // 얼럿 액션 창
    func alert() {
        let alertTitle = "원페이"
        let alertMessage = "이용료 납부가 완료되었습니다."
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) {
            UIAlertAction in
            
            Data_FeesPay.shared.duesAmount = "12000"
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FeesPayStoryID")
            
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        
        alert.addAction(ok)
        
        self.present(alert, animated: false)
    }
    
    // 송금 데이터 서버로 보내기
    func sendMoneyInfoDataSend() {
        member_srl = Data_SendMoney.shared.sendMoney_Member_srl
        totalAmount = Data_SendMoney.shared.sendMoney_TotalAmount
        cashAmount = Data_SendMoney.shared.sendMoney_CashAmount
        outName = Data_SendMoney.shared.sendMoney_OutName
        inBankCode = Data_SendMoney.shared.sendMoney_InBankCode
        inBankCode2 = Data_SendMoney.shared.sendMoney_InBankCode2
        inAccNo = Data_SendMoney.shared.sendMoney_InAccNo
        do {
            
            let url = serviceUrl.realServiceUrl + "/onepay/rest/sendPoint"
            let param: Parameters = [
                "member_srl": member_srl,
                "totalAmount": totalAmount,
                "cashAmount": cashAmount,
                "outName": outName,
                "inBankCode": inBankCode,
                "inBankCode2": inBankCode2,
                "inAccNo": inAccNo
            ]

            
            print("member_srl =" + " \(member_srl)")
            print("totalAmount =" + " \(totalAmount)")
            print("cashAmount =" + " \(cashAmount)")
            print("outName =" + " \(outName)")
            print("inBankCode =" + " \(inBankCode)")
            print("inBankCode2 =" + " \(inBankCode2)")
            print("inAccNo =" + " \(inAccNo)")

            
            
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                print("JSON=\(response.result.value!)")
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        print("//---------->    송금 성공  <----------//")
                        ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneySuccessStoryID")
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        
                        self.displayMsg(title: "원페이", msg: "잠시 후에 다시 시도해 주세요.")
                        print("//---------->    수취 조회 실패  <----------//")
                        
                    } else {
                        
                        self.displayMsg(title: "원페이", msg: "잠시 후에 다시 시도해 주세요.")
                        
                    }
                    
                    print("수취조회 resultCode = \(jsonObject["resultCode"]!)")
                    print("수취조회 resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    // 월 이용료 결제 데이타 서버로 보내기
    func feesPayDataSend() {
        self.activity.isHidden = false
        self.activity.startAnimating()
        let member_srl = Data_MemberInfo.shared.member_srl
        let type = "month"
        
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/payDues"
            let param: Parameters = [
                "member_srl": member_srl,
                "type": type
            ]
            print(param)
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                
                if let jsonObject = response.result.value as? [String: Any] {
                    
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        print("이용료 납부 성공.")
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
                        self.alert()
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        print("이용료 납부 실패.")
                        
                        self.displayMsg(title: "원페이", msg: "\(jsonObject["resultMessage"]!)")
                        self.navigationController?.popViewController(animated: true)

                    }
                    print("이용료 납부 resultCode = \(jsonObject["resultCode"]!)")
                    print("이용료 납부 resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    // 유니크 넘버 생성용 현재 시간 생성
    func tranInsertDataLoad(){
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmmssSSS"
        let time = formatter.string(from: currentDate)
        uniqueTime = time
    }
    
    // 큐알 코드 결제 데이터 서버로 보내기
    func qrPayDataSend() {
        print("🅰️ 큐알 코드")
        let pay_type = "05"
        let tran_type = "D1"
        let amount = Data_QRCode.shared.qrcode_totalAmount
        let total_amt = Data_QRCode.shared.qrcode_totalAmount
        let vat = "0"
        let point_amt = "0"
        let service_amt = "0"
        let cncl_gb = ""
        let cncl_dd = ""
        let account_no = Data_MemberAsset.shared.acc_no
        let iss_cd = ""
        let acq_cd = ""
        let member_srl = Data_MemberInfo.shared.member_srl
        let shop_member_srl = Data_QRCode.shared.qrcode_shopSrl
        let user_id = Data_MemberInfo.shared.user_id 
        let mall_id = ""
        let tid = ""
        let sub_mall_id = ""
        let order_no = Data_QRCode.shared.qrcode_orderNumber
        let rep_goods = Data_QRCode.shared.qrcode_productName
        let point_cash = "0"
        let return_url = Data_QRCode.shared.qrcode_returnUrl
        let unique_no = uniqueTime + "_" + shop_member_srl + "_" + member_srl
        let selectedWord = uniqueTime.suffix(13)
        var a = Array(selectedWord)
        a.shuffle()
        let apprv_no = String(a)
        
        do {
            print("🅰️ 큐알 코드 2")
            let url = serviceUrl.realServiceUrl + "/onepay/rest/tranInsert"
            let param: Parameters = [
                "unique_no": unique_no,
                "pay_type": pay_type,
                "tran_type": tran_type,
                "amount": amount,
                "total_amt": total_amt,
                "vat": vat,
                "point_amt": point_amt,
                "service_amt": service_amt,
                "cncl_gb": cncl_gb,
                "cncl_dd": cncl_dd,
                "apprv_no": apprv_no,
                "account_no": account_no,
                "iss_cd": iss_cd,
                "acq_cd": acq_cd,
                "member_srl": member_srl,
                "shop_member_srl": shop_member_srl,
                "user_id": user_id,
                "mall_id": mall_id,
                "tid": tid,
                "sub_mall_id": sub_mall_id,
                "order_no": order_no,
                "rep_goods": rep_goods,
                "point_cash": point_cash,
                "return_url": return_url,
                ]
            
            print("🅰️ 큐알 코드 3 :\(param)")
/*
            print(param)
            print("unique_no = " +  unique_no)
            print("pay_type = " +  pay_type)
            print("tran_type = " +  tran_type)
            print("amount = " +  amount)
            print("total_amt = " +  total_amt)
            print("vat = " +  vat)
            print("point_amt = " +  point_amt)
            print("service_amt = " +  service_amt)
            print("cncl_gb  = " +  cncl_gb )
            print("cncl_dd  = " +  cncl_dd )
            print("apprv_no = " +  apprv_no)
            print("account_no = " +  account_no)
            print("iss_cd = " +  iss_cd)
            print("acq_cd = " +  acq_cd)
            print("member_srl = " +  member_srl)
            print("shop_member_srl = " +  shop_member_srl)
            print("user_id = " +  user_id)
            print("mall_id  = " +  mall_id )
            print("tid  = " +  tid )
            print("sub_mall_id = " +  sub_mall_id )
            print("order_no = " +  order_no)
            print("rep_goods = " +  rep_goods)
            print("point_cash = " +  point_cash)
            print("return_url = " +  return_url)
 */
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
                        print("🅰️ 큐알 코드 4 결제 성공")
                        self.displayMsg(title: "원페이", msg: "결제 성공")
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                        
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                        
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "2" {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                        
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    
    // 스마트콘 주문 처리
    func smartConBuyDataSend() {
        self.activity.isHidden = false
        self.activity.startAnimating()
        print("스마트콘 주문시작")
        select_Brand_goods = Data_SmartCon.shared.smartCon_SelectGoodsInfo
        /*
         select_Brand_goods[0] : 브랜드 네임
         select_Brand_goods[1] : 상품코드
         select_Brand_goods[2] : 상품 네임
         select_Brand_goods[3] : 상품 이지미 url
         select_Brand_goods[4] : 상품 상세 내용
         select_Brand_goods[5] : 상품 가격
         select_Brand_goods[6] : 상품 취소 가능 여부
         select_Brand_goods[7] : 상품 공급가
         select_Brand_goods[8] : 상품 수수료율
         */
        
        
        let member_srl = Data_MemberInfo.shared.member_srl
        let event_id = Data_SmartCon.shared.smartCon_EventId
        let goods_id = self.select_Brand_goods[1]
        let goods_name = self.select_Brand_goods[2]
        let brand_name = self.select_Brand_goods[0]
        let disc_price = self.select_Brand_goods[7]
        let disc_rate = self.select_Brand_goods[8]
        let price = self.select_Brand_goods[5]
        let pay_type = "05"
        /*
         01 : 현금
         02 : 카드
         03 : 상품권
         05 : 포인트(캐시/선불)
         */
        
        let tran_type = "D1"
        /*
         D1 : 승인/주문
         D2 : 취소
         C0 : 충전
         C1 : 송금
         M1 : 적립
         M2 : 적립 취소
         T1 : 전환
         */
        
        let vat = "0" // 부가가치세 "0" 고정
        let point_amt = "0"  // 포인트 사용 금액 "0" 고정
        let service_amt = "0" // 봉사료 "0" 고정
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/couponCreate"
            let param: Parameters = [
                "member_srl": member_srl,
                "event_id": event_id,
                "goods_id": goods_id,
                "goods_name": goods_name,
                "brand_name": brand_name,
                "disc_price": disc_price,
                "disc_rate": disc_rate,
                "price": price,
                "pay_type": pay_type,
                "tran_type": tran_type,
                "vat": vat,
                "point_amt": point_amt,
                "service_amt": service_amt
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in

                if let jsonObject = response.result.value as? [String: Any] {
                    
                    if String(describing: (jsonObject["resultCode"]!)) == "0"{

                        self.displayMsg(title: "원페이 스마트콘", msg: "스마트콘 구매 실패")
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        
                        let title = "원페이 스마트콘 \n"
                        let message = "원페이 스마트콘 쿠폰 구매가 완료되었습니다." + "\n" + "\n"
                            + "구매하신 쿠폰은 [원페이 스마트콘 > 내 쿠폰함] 에서 확인하실 수 있습니다."
                        
                        
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        
                        
                        let action = UIAlertAction(title: "확인", style: .default) {
                            UIAlertAction in
                            
                            self.myCouponListLoad()

                        }
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.left
                        
                        let messageText = NSMutableAttributedString(
                            string: "원페이 스마트콘 쿠폰 구매가 완료되었습니다." + "\n" + "\n"
                                + "구매하신 쿠폰은 [원페이 스마트콘 >  내 쿠폰함] 에서 확인하실 수 있습니다.",
                            attributes: [
                                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light),
                                NSAttributedString.Key.foregroundColor : UIColor.black
                            ]
                        )
                        
                        alert.setValue(messageText, forKey: "attributedMessage")

                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil)

                    } else if String(describing: (jsonObject["resultCode"]!)) == "2" {
                        self.displayMsg(title: "원페이 스마트콘", msg: "잔액부족")
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                    } else if String(describing: (jsonObject["resultCode"]!)) == "3" {
                        self.displayMsg(title: "원페이 스마트콘", msg: "구매중지회원 입니다.")
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    // 스마트콘 취소 데이터 보내기
    func myCouponCancelDataSend() {
        self.activity.isHidden = false
        self.activity.startAnimating()
        
        myCon_Vali_Detail_Data = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_Detail_Data
        
        let tr_id  = self.myCon_Vali_Detail_Data[4]
        let event_id = Data_SmartCon.shared.smartCon_EventId
        let valid_end = self.myCon_Vali_Detail_Data[2]
        
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/cancelCoupon"
            let param: Parameters = [
                "tr_id" : tr_id,
                "event_id" : event_id,
                "valid_end" : valid_end
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                    
                case .success(let value):
                    
                    self.myCouponCancelData = JSON(value)

                    let title = "원페이 스마트콘"
                    let message = "해당 원페이 스마트콘의 구매 취소가 완료되었습니다."
                    
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "확인", style: .default) {
                        UIAlertAction in
                        self.myCouponListLoad()
                    }

                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    

    // 보유쿠폰 데이터 불러오기
    func myCouponListLoad() {
        let member_srl = Data_MemberInfo.shared.member_srl
        let start_num = "0"
        let list_num = "5"
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/myCoupon"
            let param: Parameters = [
                "member_srl" : member_srl,
                "start_num" : start_num,
                "list_num" : list_num
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                    
                case .success(let value):
                    self.myConListData = JSON(value)
                    print(self.myConListData)
                    Data_SmartCon_MyCon.shared.myCon_tr_id_array =  self.myConListData["couponArr"].arrayValue.map({$0["tr_id"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_member_srl_array =  self.myConListData["couponArr"].arrayValue.map({$0["member_srl"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_event_id_array =  self.myConListData["couponArr"].arrayValue.map({$0["event_id"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_goods_id_array =  self.myConListData["couponArr"].arrayValue.map({$0["goods_id"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_disc_price_array =  self.myConListData["couponArr"].arrayValue.map({$0["disc_price"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_disc_rate_array =  self.myConListData["couponArr"].arrayValue.map({$0["disc_rate"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_price_array =  self.myConListData["couponArr"].arrayValue.map({$0["price"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_order_cnt_array =  self.myConListData["couponArr"].arrayValue.map({$0["order_cnt"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_img_url_array =  self.myConListData["couponArr"].arrayValue.map({$0["img_url"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_exchange_status_array =  self.myConListData["couponArr"].arrayValue.map({$0["exchange_status"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_goods_name_array =  self.myConListData["couponArr"].arrayValue.map({$0["goods_name"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_brand_name_array =  self.myConListData["couponArr"].arrayValue.map({$0["brand_name"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_total_cnt = self.myConListData["totalCnt"].string!
                    
                    print("myCon_tr_id = " + "\(Data_SmartCon_MyCon.shared.myCon_tr_id_array)")
                    print("myCon_member_srl = " + "\(Data_SmartCon_MyCon.shared.myCon_member_srl_array)")
                    print("myCon_event_id = " + "\(Data_SmartCon_MyCon.shared.myCon_event_id_array)")
                    print("myCon_goods_id = " + "\(Data_SmartCon_MyCon.shared.myCon_goods_id_array)")
                    print("myCon_goods_id = " + "\(Data_SmartCon_MyCon.shared.myCon_disc_price_array)")
                    print("myCon_disc_price = " + "\(Data_SmartCon_MyCon.shared.myCon_disc_rate_array)")
                    print("myCon_disc_rate = " + "\(Data_SmartCon_MyCon.shared.myCon_price_array)")
                    print("myCon_price = " + "\(Data_SmartCon_MyCon.shared.myCon_order_cnt_array)")
                    print("myCon_order_cnt = " + "\(self.myCon_order_cnt)")
                    print("myCon_img_url = " + "\(Data_SmartCon_MyCon.shared.myCon_img_url_array)")
                    print("myCon_exchange_status = " + "\(Data_SmartCon_MyCon.shared.myCon_exchange_status_array)")
                    print("myCon_goods_name = " + "\(Data_SmartCon_MyCon.shared.myCon_goods_name_array)")
                    print("myCon_brand_name = " + "\(Data_SmartCon_MyCon.shared.myCon_brand_name_array)")
                    
                    
                    let when = DispatchTime.now() + 0.1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        if Data_SmartCon_MyCon.shared.myCon_tr_id_array.count != 0 {
                            self.myCouponStatusLoad()
                        } else {
                            
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_SmartCon")
                            
                            self.navigationController?.pushViewController(nextVC!, animated: true)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // 스마트콘 실시간 교환상태 조회
    func myCouponStatusLoad() {
        
        let tr_id  = Data_SmartCon_MyCon.shared.myCon_tr_id_array[cnt]
        let event_id = Data_SmartCon.shared.smartCon_EventId
        
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/validateCoupon"
            
            let param: Parameters = [
                "tr_id" : tr_id,
                "event_id" : event_id
            ]
            
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                
                switch response.result {
                    
                case .success(let value):
                    self.myConList_ValiData = JSON(value)
                    
                    let vali_1 = self.myConList_ValiData["claim_type"].string!
                    let vali_2 = self.myConList_ValiData["valid_start"].string!
                    let vali_3 = self.myConList_ValiData["valid_end"].string!
                    let vali_4 = self.myConList_ValiData["tr_id"].string!
                    let vali_5 = self.myConList_ValiData["exchange_date"].string!
                    let vali_6 = self.myConList_ValiData["order_date"].string!
                    let vali_7 = self.myConList_ValiData["exchange_status"].string!
                    let vali_8 = self.myConList_ValiData["cancel_period"].string!
                    let vali_9 = self.myConList_ValiData["cancelable"].string!
                    
                    self.myCon_Vali_claim_type.append(vali_1)
                    self.myCon_Vali_valid_start.append(vali_2)
                    self.myCon_Vali_valid_end.append(vali_3)
                    self.myCon_Vali_tr_id.append(vali_4)
                    self.myCon_Vali_exchange_date.append(vali_5)
                    self.myCon_Vali_order_date.append(vali_6)
                    self.myCon_Vali_exchange_status.append(vali_7)
                    self.myCon_Vali_cancel_period.append(vali_8)
                    self.myCon_Vali_cancelable.append(vali_9)
                    
                    self.cnt += 1
                    
                    if self.cnt < Data_SmartCon_MyCon.shared.myCon_brand_name_array.count  {
                        self.myCouponStatusLoad()
                        
                    } else {
                        
                        print(self.myCon_Vali_claim_type)
                        print(self.myCon_Vali_valid_start)
                        print(self.myCon_Vali_valid_end)
                        print(self.myCon_Vali_tr_id)
                        print(self.myCon_Vali_exchange_date)
                        print(self.myCon_Vali_order_date)
                        print(self.myCon_Vali_exchange_status)
                        print(self.myCon_Vali_cancel_period)
                        print(self.myCon_Vali_cancelable)
                        
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_claim_type = self.myCon_Vali_claim_type
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_valid_start = self.myCon_Vali_valid_start
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_valid_end = self.myCon_Vali_valid_end
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_tr_id = self.myCon_Vali_tr_id
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_exchange_date = self.myCon_Vali_exchange_date
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_order_date = self.myCon_Vali_order_date
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_exchange_status = self.myCon_Vali_exchange_status
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_cancel_period = self.myCon_Vali_cancel_period
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_cancelable = self.myCon_Vali_cancelable
                        
                        
                        self.myCon_Vali_claim_type.removeAll()
                        self.myCon_Vali_valid_start.removeAll()
                        self.myCon_Vali_valid_end.removeAll()
                        self.myCon_Vali_tr_id.removeAll()
                        self.myCon_Vali_exchange_date.removeAll()
                        self.myCon_Vali_order_date.removeAll()
                        self.myCon_Vali_exchange_status.removeAll()
                        self.myCon_Vali_cancel_period.removeAll()
                        self.myCon_Vali_cancelable.removeAll()
                        self.myCon_tr_id.removeAll()
                        self.myCon_member_srl.removeAll()
                        self.myCon_event_id.removeAll()
                        self.myCon_goods_id.removeAll()
                        self.myCon_disc_price.removeAll()
                        self.myCon_disc_rate.removeAll()
                        self.myCon_price.removeAll()
                        self.myCon_order_cnt.removeAll()
                        self.myCon_img_url.removeAll()
                        self.myCon_exchange_status.removeAll()
                        self.myCon_goods_name.removeAll()
                        self.myCon_brand_name.removeAll()
                        
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_SmartCon")
                        
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}


extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue}
            self.swapAt(i, j)
        }
    }
}
