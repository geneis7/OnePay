//
//  QRCodePayCheckVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 2. 7..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class QRCodePayCheckVC: UIViewController {
    
    @IBOutlet weak var qRCodePayCheckTextView: UITextView!
    @IBOutlet weak var btn_QrPaySubmit: UIButton!
    
    var type: String = ""
    var memberSrl: String = ""
    var mallName: String = ""
    var returnUrl: String = ""
    var totalAmount: String = ""
    var orderNumber: String = ""
    var productName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_QrPaySubmit.layer.cornerRadius = 10
        qRCodePayCheckTextView.isEditable = false
        
        qrDataLoad()
        
        
        guard let commaAccount = Int(self.totalAmount)?.withComma else { return }
        
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            let qrCodePayCheckTitleText:String = "결제하기를 누르시면 \n\(self.mallName) 에서\n 결제 요청한 \n[ \(self.productName) ]의 \n결제 포인트 \n\(String(describing: commaAccount)) P가 결제됩니다."
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: qrCodePayCheckTitleText as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#1F8395FF")!, range: NSRange(location:12,length:self.mallName.count))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#1F8395FF")!, range: NSRange(location:11 + self.mallName.count + 16 ,length:self.productName.count))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#1F8395FF")!, range: NSRange(location:11 + self.mallName.count + 13 + self.productName.count + 16,length: commaAccount.count))
            print("결제금액 카운트")
            print(commaAccount.count)
            self.qRCodePayCheckTextView.attributedText = myMutableString
            self.qRCodePayCheckTextView.textAlignment = .center
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 뒤로가기 버튼
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 큐알코드 결제 버튼
    @IBAction func qrCodePaymentBtn(_ sender: Any) {
        
        let feesPayCheck = Data_FeesPay.shared.duesAmount
        if feesPayCheck != "" {
            Data_SendMoney.shared.sendMoney_Flag = "qrPay"
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SendMoneyPaymentPasswordStoryID")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        } else {
            displayMsg(title: "원페이", msg: "이용료 납부를 해주셔야 이용가능합니다.")
        }
    }
    
    // 스캔한 큐알코드 데이터 로드
    func qrDataLoad() {
        type = Data_QRCode.shared.qrcode_type
        mallName = Data_QRCode.shared.qrcode_mallName
        memberSrl = Data_QRCode.shared.qrcode_shopSrl
        orderNumber = Data_QRCode.shared.qrcode_orderNumber
        productName = Data_QRCode.shared.qrcode_productName
        returnUrl = Data_QRCode.shared.qrcode_returnUrl
        totalAmount = Data_QRCode.shared.qrcode_totalAmount
    }
}
