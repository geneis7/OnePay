//
//  FeesPayVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 16..
//  Copyright © 2018년 유하늘. All rights reserved.
//


import UIKit
import SwiftyJSON
import Alamofire

class FeesPayVC: UIViewController {
    
    @IBOutlet weak var feesPayMemberNameLabel: UILabel!
    @IBOutlet weak var feesPayMonthAmountLabel: UILabel!
    @IBOutlet weak var feesPayExDateLabel: UILabel!
    @IBOutlet weak var feesPayTitleLabel: UILabel!
    @IBOutlet weak var feesPayBtnOutlet: UIButton!
    
    let serviceUrl = UrlData()
    var feesPayData:JSON = JSON.init(rawValue: [])!
    var eXlastDay:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerTrans_FeesPayDataLoad.shared.feesPayDataLoad()
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.defaultSetting()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultSetting(){
        let memberName = Data_MemberInfo.shared.user_name
        let duesAmount = Data_FeesPay.shared.duesAmount
        let exDate = Data_FeesPay.shared.exDate
        
        lastDayCheck()
        
        // 회원 이름
        self.feesPayMemberNameLabel?.text = memberName
        
        // 월 이용료
        if duesAmount == "" {
            self.feesPayMonthAmountLabel?.text = "12,000 P"
        } else {
            self.feesPayMonthAmountLabel?.text = (Int(duesAmount)?.withComma)! + " P"
        }
        
        // 이용기간
        if exDate == "" {
            self.feesPayExDateLabel?.text = "미납 (서비스 이용 불가)"
        } else if exDate.count > 8{
            self.feesPayExDateLabel?.text = exDate
        } else {
            let year = exDate.prefix(4)
            let month = exDate.suffix(2)
            self.feesPayExDateLabel?.text = "\(year)" + "년 " + "\(month)" + "월 " + "\(eXlastDay)" + "일까지 이용 가능"
        }
        
        let feesPayTitleText:String = "원활한 서비스 제공을 위해\n 원페이는 [유료회원제]로 운영됩니다."
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: feesPayTitleText as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#1F8395FF")!, range: NSRange(location:22,length:7))
        feesPayTitleLabel.attributedText = myMutableString
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        let feesPayCheck = Data_FeesPay.shared.duesAmount
        if feesPayCheck != "" {
//            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
//            self.navigationController?.pushViewController(nextVC!, animated: true)

            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func feesPayBtn(_ sender: Any) {
        
        let member_acc_no = Data_MemberAsset.shared.acc_no
        let member_cash_bal = Data_MemberAsset.shared.cash_bal
        
        if member_acc_no == "" {
            displayMsg(title: "원페이", msg: "가상계좌를 먼저 등록하세요.")
        } else if Int(member_cash_bal)! < 12000 {
            displayMsg(title: "원페이", msg: "잔액이 부족합니다.")
        } else {
            let alertTitle = "원페이"
            let alertMessage = "월 이용료 12,000P가 포인트로 결제됩니다."
            
            let cancel = UIAlertAction(title: "취소", style: .destructive)
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default) {
                UIAlertAction in
                
                Data_SendMoney.shared.sendMoney_Flag = "feesPay"
                
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyPaymentPasswordStoryID")
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: false)
        }
        
    }
    
    func lastDayCheck() {
        
        let calendar = Calendar.current
        var component = calendar.dateComponents([.day,.month,.year], from: Date())
        // Get necessary date components
        // set last of month
        component.month = (component.month)! + 1
        component.day = 1
        
        guard let tDateMonth: Date = calendar.date(from: component) else { return }
        let date = String(describing: tDateMonth).prefix(10)
        let lastDay = date.suffix(2)
        eXlastDay = String(lastDay)
    }
    
    @IBAction func goToFeesPayHistory(_ sender: Any) {
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "FeesPayHistoryStoryID")
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
}
