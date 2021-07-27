//
//  FirstViewController.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 13..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableVIew: UITableView!
    
    let boardList:[String] = [
        "메인 뷰", // 뷰 완료
        "로그인 뷰" + " - 개발 완료 ☑️" ,// 개발 완료 ✔︎
        "약관동의 뷰" + " - 개발 완료 ☑️", // 개발 완료 ✔︎
        "회원가입 뷰" + " - 수정 필요 🛠 ", // 뷰 완성 , 수정 필요
        "카드정보 뷰" + " - 개발 완료 ☑️", // 뷰 완료 , QR 코드 연동기능 남음
        "가상계좌등록 뷰" + " - 개발 완료 ☑️", // 개발 완료 ✔︎
        "계좌보유 뷰" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "충전내역 뷰" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "거래내역 조회 뷰" + " - 개발 완료☑️",  // 개발 완료 ✔︎
        "고객센터 뷰" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "보노가맹점신청 뷰" + " - 개발 중 ❗️ ", // 뷰 완료
        "전자금융거래 이용 약관 뷰" + " - 개발 완료 ☑️", // 개발 완료 ✔︎
        "은행선택 뷰" + " - 개발 완료☑️",  // 개발 완료 ✔︎
        "결제용 비밀번호 등록 뷰" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "송금 정보 입력 뷰" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "이용료 납부" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "이용료 납부 내역" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "송금 확인" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "송금 결제 비밀번호" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "송금 결제 완료" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "QR 코드 결제 확인" + " - 개발 완료☑️", // 개발 완료 ✔︎
        "회원정보 수정 뷰" + " - 개발 중 ❗️ "] // 뷰 완료
    
    let boardListStoryID:[String] = ["SWRevealStoryID",
                                     "LoginStoryID",
                                     "AcceptTermsStoryID",
                                     "SignUpStoryID",
                                     "SWReveal_CardInfo",
                                     "SWReveal_MyAccount",
                                     "SWReveal_MyAccountHave",
                                     "SWReveal_ChargeHistory",
                                     "SWReveal_TransHistory",
                                     "SWReveal_ServiceCenter",
                                     "ShopApplyVC",
                                     "ElectronicFinanceStoryID",
                                     "BankStoryID",
                                     "PaymentPasswordStoryID",
                                     "SendMoneyInfoStoryID",
                                     "FeesPayStoryID",
                                     "FeesPayHistoryStoryID",
                                     "SendMoneyCheckStoryID",
                                     "SendMoneyPaymentPasswordStoryID",
                                     "SendMoneySuccessStoryID",
                                     "QRCodePayCheckStoryID",
                                     "MemberInfoStoryID"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("퍼스트 뷰")
        tableVIew.delegate = self
        tableVIew.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVIew.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = boardList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ControllerName = boardListStoryID[indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: ControllerName)
        print(ControllerName)
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
}
