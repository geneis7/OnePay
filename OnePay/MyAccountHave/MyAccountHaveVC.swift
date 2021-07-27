//
//  MyAccountHaveVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 10..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class MyAccountHaveVC: UIViewController {

    @IBOutlet weak var myAccountHaveSlideMenuBtnOutlet: UIButton!
    @IBOutlet weak var myAccountHaveBankNameLabel: UILabel!
    @IBOutlet weak var myAccountHaveAccNumLabel: UILabel!
    @IBOutlet weak var myAccountHavePointLabel: UILabel!
    @IBOutlet var myAccountHaveView: UIView!
    @IBOutlet weak var btn_SendMoney: UIButton!
    @IBOutlet weak var btn_CopyAccountNum: UIButton!
    @IBOutlet weak var imgView_BankBackGround: UIImageView!
    
    let serviceUrl = UrlData()
    
    var bankListData:JSON = JSON.init(rawValue: [])!
    var bankList:[String:String] = [:]
    var bankListName:[String] = []
    var bankListCode:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView_BankBackGround.layer.cornerRadius = 5
        btn_SendMoney.layer.cornerRadius = 10
        btn_CopyAccountNum.layer.cornerRadius = 10
        
        myAccountHaveView.onSwipeLeft{ _ in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_ChargeHistory")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        
        myAccountHaveView.onSwipeRight{ _ in
            self.navigationController?.popViewController(animated: true)

        }
        
        
        myAccountHavePointLabel.text = ""
        myAccountHaveAccNumLabel.text = ""
        myAccountHaveBankNameLabel.text = ""
        bankListDataLoad()
        ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
        
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.defaultSettings()
            self.configureAppearance()
        }
        
        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            self.myAccountHaveSlideMenuBtnOutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
//            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
            self.view.addGestureRecognizer(revealVC.tapGestureRecognizer())
        }
        

        // Do any additional setup after loading the view.
    }

    func defaultSettings(){
        
        
        
        let acc_no = Data_MemberAsset.shared.acc_no
        let cash_bal = Data_MemberAsset.shared.cash_bal
        let bank_code = Data_MemberInfo.shared.bank_code
        
        
        // 은행 정보
        if bank_code == "" {
            let bank_code2 = Data_BankInfo.shared.selectBankCode
            if bank_code2 == ""  {
                myAccountHaveBankNameLabel?.text = ""
            } else {
                myAccountHaveBankNameLabel?.text = Data_BankInfo.shared.bankSorted_Code[bank_code2]
            }
        } else {
            myAccountHaveBankNameLabel?.text = Data_BankInfo.shared.bankSorted_Code[bank_code]
        }
        
        // 가상계좌 정보
        if acc_no == "" {
                myAccountHaveAccNumLabel?.text = ""
        } else {
                myAccountHaveAccNumLabel?.text = acc_no
        }
        
        // 보유포인트 정보
        if cash_bal == "" {
                myAccountHavePointLabel?.text = ""
        } else {
            myAccountHavePointLabel?.text = "보유 포인트 : " + (Int(cash_bal)?.withComma)! + " P"
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pointTransferBtn(_ sender: Any) {
        
        let feesPayCheck = Data_FeesPay.shared.duesAmount

        print("✅✅✅✅✅✅✅✅✅✅")
        print(feesPayCheck)
        
        if feesPayCheck != "" {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyInfoStoryID")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        } else {
                displayMsg(title: "원페이", msg: "이용료 납부를 해주셔야 이용가능합니다.")
        }

    }
    
    @IBAction func myAccoutNumCopyBtn(_ sender: Any) {
        UIPasteboard.general.string = Data_MemberAsset.shared.acc_no
        Toast(text: "계좌번호가 복사 되었습니다.").show()
    }
    
    // Toaster 알림 메세지 커스텀
    func configureAppearance() {
        let appearance = ToastView.appearance()
        appearance.backgroundColor = .darkGray
        appearance.textColor = .white
        appearance.font = .boldSystemFont(ofSize: 15)
        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        appearance.bottomOffsetPortrait = 100
        appearance.cornerRadius = 20
    }
    
    func bankListDataLoad(){
        let url = serviceUrl.realServiceUrl + "/onepay/rest/bankList"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.bankListData = JSON(value)
                Data_BankInfo.shared.bankListName =  self.bankListData["bankList"].arrayValue.map({$0["bank_name"].stringValue})
                Data_BankInfo.shared.bankListCode =  self.bankListData["bankList"].arrayValue.map({$0["bank_code"].stringValue})
                
                var nameListCnt = 0
                var codeListCnt = 0
                while nameListCnt != Data_BankInfo.shared.bankListName.count {
                    Data_BankInfo.shared.bankSorted_Code[Data_BankInfo.shared.bankListCode[codeListCnt]] = Data_BankInfo.shared.bankListName[nameListCnt]
                    nameListCnt = nameListCnt + 1
                    codeListCnt = codeListCnt + 1
                }

            case .failure(let error):
                print(error)
            }
            
        }
    }

}
