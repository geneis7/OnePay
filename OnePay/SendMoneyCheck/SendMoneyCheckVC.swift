//
//  SendMoneyCheckVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 23..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class SendMoneyCheckVC: UIViewController {
    
    @IBOutlet weak var sendMoneyCheckBankNameLabel: UILabel!
    @IBOutlet weak var sendMoneyCheckAccNoLabel: UILabel!
    @IBOutlet weak var sendMoneyCheckRecipientNameLabel: UILabel!
    @IBOutlet weak var sendMoneyCheckPointLabel: UILabel!
    @IBOutlet weak var sendMoneyCheckFeesLabel: UILabel!
    @IBOutlet weak var btn_SendMoneyCheckSubmit: UIButton!
    
    var member_srl:String = ""
    var totalAmount:String  = ""
    var cashAmount:String  = ""
    var outName:String  = ""
    var inBankCode:String  = ""
    var inBankCode2:String  = ""
    var inAccNo:String  = ""
    var inName:String  = ""
    var fee:String  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_SendMoneyCheckSubmit.layer.cornerRadius = 10
        sendMoneyInfoDataLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendMoneyInfoDataLoad() {
        
        member_srl = Data_SendMoney.shared.sendMoney_Member_srl
        totalAmount = Data_SendMoney.shared.sendMoney_TotalAmount
        cashAmount = Data_SendMoney.shared.sendMoney_CashAmount
        outName = Data_SendMoney.shared.sendMoney_OutName
        inBankCode = Data_SendMoney.shared.sendMoney_InBankCode
        inBankCode2 = Data_SendMoney.shared.sendMoney_InBankCode2
        inAccNo = Data_SendMoney.shared.sendMoney_InAccNo
        inName = Data_SendMoney.shared.sendMoney_InName
        fee = Data_SendMoney.shared.sendMoney_Fee
        
        let bankName = Data_BankInfo.shared.selectBankName
        
        sendMoneyCheckBankNameLabel.text = bankName
        sendMoneyCheckAccNoLabel.text = (inAccNo)
        sendMoneyCheckRecipientNameLabel.text = (inName)
        sendMoneyCheckPointLabel.text = (Int(totalAmount)?.withComma)!  + " P"
        sendMoneyCheckFeesLabel.text = (Int(fee)?.withComma)! + " P"
        
    }
    
    @IBAction func sendMoneyCheckSubmitBtn(_ sender: Any) {
        guard let amount = Int(totalAmount) else { return }
        
        
        let title = "OnePay \n\n"
        let message = "받으시는 분 : " + "\(inName)" + "\n"
            + "송금포인트 : " + "\(String(describing: amount.withComma))" + " P\n"
            + "송금수수료 : " + "\(fee)" + " P\n\n"
            + "송금 내용을 확인 하신 후, 확인을 눌러주세요."
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        let action = UIAlertAction(title: "확인", style: .default) {
            UIAlertAction in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyPaymentPasswordStoryID")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: "받으시는 분 : " + "\(inName)" + "\n"
                + "송금포인트  : " + "\(String(describing: amount.withComma))" + " P\n"
            + "송금수수료  : " + "\(fee)" + " P\n\n"
            + "송금 내용을 확인 하신 후, 확인을 눌러주세요.",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]
        )
        
        alert.setValue(messageText, forKey: "attributedMessage")
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
