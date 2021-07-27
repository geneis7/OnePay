//
//  SendMoneyInfoVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 9..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KBNumberPad
import Toaster

class SendMoneyInfoVC: UIViewController,UITextFieldDelegate,KBNumberPadDelegate {
    
    @IBOutlet weak var sendMoneyInfoFirstView: UIView!
    @IBOutlet weak var sendBankNameView: UIView!
    @IBOutlet weak var sendMoneyInfoSecondView: UIView!
    @IBOutlet weak var dropButtonView: UIView!
    @IBOutlet weak var firstLineLabel: UIImageView!
    @IBOutlet weak var secondLineLabel: UIImageView!
    @IBOutlet weak var sendMoneyAccNoSmallLabel: UILabel!
    @IBOutlet weak var sendMoneyPointSmallLabel: UILabel!
    
    @IBOutlet weak var inputSendAccountNumTF: UITextField!
    @IBOutlet weak var inputSendPointTF: UITextField!
    @IBOutlet weak var sendMoneySubmitBtn: UIButton!
    
    let serviceUrl = UrlData()
    var button = dropDownBtn()
    
    var bankListData:JSON = JSON.init(rawValue: [])!
    var bankList:[String:String] = [:]
    var bankListSeq:[String] = []
    var bankListName:[String] = []
    var bankListCode:[String] = []
    var textFieldFlag = true
    var accNo = ""
    var point = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMoneySubmitBtn.layer.cornerRadius = 10
        numberPadSetting()
        bankListDataLoad()
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.defaultSetting()
            self.inputSendAccountNumTF.delegate = self
            self.inputSendPointTF.delegate = self
            
            
            self.button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            self.button.setTitle("     은행 선택         ▾", for: .normal)
            
            self.button.translatesAutoresizingMaskIntoConstraints = false
            self.button.setTitleColor(UIColor.lightGray, for: .normal)
            self.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            self.button.contentHorizontalAlignment = .left
            
            
            //Add Button to the View Controller
            self.view.addSubview(self.button)
            
            
            //button Constraints

            self.button.topAnchor.constraint(equalTo: self.dropButtonView.topAnchor).isActive = true
            self.button.bottomAnchor.constraint(equalTo: self.dropButtonView.bottomAnchor).isActive = true
            self.button.rightAnchor.constraint(equalTo: self.dropButtonView.rightAnchor, constant : -20).isActive = true
            self.button.leftAnchor.constraint(equalTo: self.sendBankNameView.rightAnchor, constant : 20 ).isActive = true
            
            self.button.dropView.backgroundColor = .white
            
            self.button.dropView.dropDownOptions = Data_BankInfo.shared.bankListName
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputSendPointTF.resignFirstResponder()
        inputSendAccountNumTF.resignFirstResponder()
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        //        self.navigationController?.popViewController(animated: true)
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccountHave")
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    @IBAction func sendMoneySubmitBtn(_ sender: Any) {
        sendMoneyInfoDataLoad()
    }
    
    func numberPadSetting(){
        let numberPad = KBNumberPad()
        let str = "clear"
        
        inputSendAccountNumTF.inputView = numberPad
        inputSendPointTF.inputView = numberPad
        
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
        if textFieldFlag == true {
            accNo = accNo + "\(number)"
            inputSendAccountNumTF.text = accNo
        } else {
            point = point  + "\(number)"
            inputSendPointTF.text = point
        }
    }
    
    func onDoneClicked(numberPad: KBNumberPad) {
        inputSendPointTF.resignFirstResponder()
        inputSendAccountNumTF.resignFirstResponder()
    }
    
    func onClearClicked(numberPad: KBNumberPad) {
        if textFieldFlag == true {
            let str_drop_last = accNo.dropLast()
            accNo = String(str_drop_last)
            inputSendAccountNumTF.text = accNo
        } else {
            let str_drop_last = point.dropLast()
            point = String(str_drop_last)
            inputSendPointTF.text = point
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textFieldFlag == true {
            inputSendAccountNumTF.text = ""
            accNo = ""
        } else {
            inputSendPointTF.text = ""
            point = ""
        }
        return true
    }
    
    @IBAction func accNoTFtouched(_ sender: Any) {
        textFieldFlag = true
    }
    @IBAction func pointTFtouched(_ sender: Any) {
        textFieldFlag = false
    }
    
    
    @IBAction func sendMoneyAccNoSmallLabelAction(_ sender: UITextField) {
        inputSendAccountNumTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        sendMoneyAccNoSmallLabel.isEnabled = true
        sendMoneyAccNoSmallLabel.text = "받는분 계좌번호(-제외)"
    }
    
    
    @IBAction func sendMoneyAccNoSmallLabelAction2(_ sender: UITextField) {
        if inputSendAccountNumTF?.text == "" {
            inputSendAccountNumTF.attributedPlaceholder = NSAttributedString(string: "받는분 계좌번호 (-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            sendMoneyAccNoSmallLabel.text = ""
            sendMoneyAccNoSmallLabel.isEnabled = false
        }
    }
    
    @IBAction func sendMoneyPointSmallLabelAction(_ sender: UITextField) {
        let member_cash_bal = Data_MemberAsset.shared.cash_bal
        sendMoneyPointSmallLabel?.text = "보유 포인트 : " + "\(String(describing: member_cash_bal))" + " P"
        inputSendPointTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        sendMoneyPointSmallLabel.isEnabled = true
    }
    
    @IBAction func sendMoneyPointSmallLabelAction2(_ sender: UITextField) {
        let member_cash_bal = Data_MemberAsset.shared.cash_bal
        
        if inputSendPointTF?.text == "" {
            inputSendPointTF.attributedPlaceholder = NSAttributedString(string: "보유 포인트 : " + "\(String(describing: member_cash_bal))" + " P",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            sendMoneyPointSmallLabel?.text = ""
            sendMoneyPointSmallLabel?.isEnabled = false
        }
        
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputSendAccountNumTF.resignFirstResponder()
        inputSendPointTF.resignFirstResponder()
        print("슈드리턴")
        return true
    }
    
    func defaultSetting(){
        
        inputSendAccountNumTF.borderStyle = .none
        inputSendAccountNumTF.keyboardType = .numbersAndPunctuation
        inputSendAccountNumTF.clearButtonMode = .whileEditing
        inputSendAccountNumTF.autocorrectionType = UITextAutocorrectionType.no
        inputSendAccountNumTF.spellCheckingType = UITextSpellCheckingType.no
        
        inputSendAccountNumTF.attributedPlaceholder = NSAttributedString(string: "받는분 계좌번호 (-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        inputSendPointTF.borderStyle = .none
        inputSendPointTF.keyboardType = .numbersAndPunctuation
        inputSendPointTF.clearButtonMode = .whileEditing
        inputSendPointTF.autocorrectionType = UITextAutocorrectionType.no
        inputSendPointTF.spellCheckingType = UITextSpellCheckingType.no

        let member_cash_bal = Data_MemberAsset.shared.cash_bal
        inputSendPointTF.attributedPlaceholder = NSAttributedString(string: "보유 포인트 : " + "\(String(describing: member_cash_bal))" + " P",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        sendMoneyAccNoSmallLabel.isEnabled = false
        
    }
    
    
    func sendMoneyInfoDataLoad() {
        let member_srl = Data_MemberInfo.shared.member_srl
        guard let totalAmount = inputSendPointTF.text else { return }
        guard let cashAmount = inputSendPointTF.text else { return }
        let outName = Data_MemberInfo.shared.user_name
        guard let inAccNo = inputSendAccountNumTF.text else { return }
        let selectBankCode = Data_BankInfo.shared.bankSorted_Name[Data_BankInfo.shared.selectBankName]
        
        var inBankCode:String
        var inBankCode2:String
        
        if selectBankCode == nil {
            
            Toast(text: "은행을 선택해 주세요.").show()
            
            return
        } else {
            inBankCode2 = selectBankCode!
        }
        
        
        
        let bank = selectBankCode
        if Int(bank!)! < 100 {
            let bank_string = String(bank!)
//            inBankCode = String(describing: bank?.suffix(2))
            inBankCode = String(bank_string.suffix(2))
            
            
        } else {
            inBankCode = "00"
        }
        
        do {
            
            let url = serviceUrl.realServiceUrl + "/onepay/rest/viewHolder"
            let param: Parameters = [
                "member_srl": member_srl,
                "totalAmount": totalAmount,
                "cashAmount": cashAmount,
                "outName": outName,
                "inBankCode": inBankCode,
                "inBankCode2": inBankCode2,
                "inAccNo": inAccNo
            ]
            print("🏧")
            print(param)
            
            Data_SendMoney.shared.sendMoney_Member_srl = member_srl
            Data_SendMoney.shared.sendMoney_TotalAmount = totalAmount
            Data_SendMoney.shared.sendMoney_CashAmount = cashAmount
            Data_SendMoney.shared.sendMoney_OutName = outName
            Data_SendMoney.shared.sendMoney_InBankCode = inBankCode
            Data_SendMoney.shared.sendMoney_InBankCode2 = inBankCode2
            Data_SendMoney.shared.sendMoney_InAccNo = inAccNo
            
            /*
             "member_srl": 회원고유번호
             "totalAmount": 송금할 포인트 금액
             "cashAmount": 송금할 포인트 중 캐시금액
             "outName": 회원이름
             "inBankCode": 입금은행코드 2자리 , 첫 자리가 0이 아닐때는 "00"
             ex) 하나은행 "081" -> "81"
             ex) 한국투자증권 "243" -> "00"
             "inBankCode2": 입금은행코드 3자리 ex) 081
             "inAccNo": inAccNo
             */
            
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        print("//---------->    수취 조회 성공  <----------//")
                        
                        let inName = String(describing: (jsonObject["inName"]!))
                        let fee = String(describing: (jsonObject["fee"]!))
                        
                        Data_SendMoney.shared.sendMoney_InName = inName
                        Data_SendMoney.shared.sendMoney_Fee = fee
                        Data_SendMoney.shared.sendMoney_Flag = "sendMoney"
                        
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyCheckStoryID")
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        Toast(text: "송금 정보를 확인해 주세요.").show()
//                        self.displayMsg(title: "원페이", msg: "")
                        print("//---------->    수취 조회 실패  <----------//")
                    } else if String(describing: (jsonObject["resultCode"]!)) == "2" {
                        Toast(text: "잔액이 부족합니다.").show()
//                        self.displayMsg(title: "원페이", msg: "잔액 부족.")
                        print("//---------->    잔액 부족  <----------//")
                    } else {
                        
                        self.displayMsg(title: "OnePay", msg: "잠시 후에 다시 시도해 주세요.")
                    }
                    print("수취조회 resultCode = \(jsonObject["resultCode"]!)")
                    print("수취조회 resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    // 은행 리스트 와 코드 정보 불러오기
    func bankListDataLoad(){
        let url = serviceUrl.realServiceUrl + "/onepay/rest/bankList"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.bankListData = JSON(value)
                print("//---------->    은행 get 응답  <----------//")
                
                Data_BankInfo.shared.bankListName =  self.bankListData["bankList"].arrayValue.map({$0["bank_name"].stringValue})
                
                Data_BankInfo.shared.bankListCode =  self.bankListData["bankList"].arrayValue.map({$0["bank_code"].stringValue})
                
                
                print("\(Data_BankInfo.shared.bankListName)")
                print("\(Data_BankInfo.shared.bankListCode)")
                
                var nameListCnt = 0
                var codeListCnt = 0
                while nameListCnt != Data_BankInfo.shared.bankListName.count {
                    Data_BankInfo.shared.bankSorted_Name[Data_BankInfo.shared.bankListName[codeListCnt]] = Data_BankInfo.shared.bankListCode[nameListCnt]
                    nameListCnt = nameListCnt + 1
                    codeListCnt = codeListCnt + 1
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}


