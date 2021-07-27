//
//  ShopApplyVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 8..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SCrypto


class ShopApplyVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ShopBankNameCellProtocol,ShopApplyCompleteCellProtocol {
    
    @IBOutlet weak var shopApplyTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopApplyTV.delegate = self
        // Do any additional setup after loading the view.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        //        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
        //
        //        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    // 셀 선택할때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.shopApplyTV.reloadData()
        }
        
        let cellIndexPathNum = indexPath.row
        let viewy = self.view.frame.origin.y
        
        if cellIndexPathNum < 6 && viewy != 0 {
            self.view.frame.origin.y = 0
        }
        
    }
    
    
    
    // 키보드 화면 업
    @objc func keyboardWillShow(_ sender: Notification) {
        let indexPathNum = Data_ShopApply.shared.shopApply_IndexPathNum
        
        let info = sender.userInfo
        let kbSize: CGSize? = (info?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size
        var bkgndRect: CGRect = self.view.frame
        bkgndRect.size.height -= (kbSize?.height)!
        
        if indexPathNum == "keypad" {
            print("키 패드 :::::::::")
            self.view.frame.origin.y -= (kbSize?.height)!
        }

        
    }
    
    // 키보드 화면 다운
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
    }
    
    // 셀 로우 섹션 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    // 각각의 셀 커스텀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 보노 가맹점 신청 -> 이름 셀
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopNameCell") as! ShopNameCell
            
            
            return cell
        }
            
            // 보노 가맹점 신청 -> 기업명 셀
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCompanyNameCell") as! ShopCompanyNameCell
            return cell
        }
            
            // 보노 가맹점 신청 -> 사업자등록번호 셀
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopBusinessNumCell") as! ShopBusinessNumCell
            return cell
        }
            
            // 보노 가맹점 신청 -> 은행명 셀
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopBankNameCell") as! ShopBankNameCell
            
            cell.delegate = self
            return cell
        }
            
            // 보노 가맹점 신청 -> 예금주 셀
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopAccoutHolderCell") as! ShopAccoutHolderCell
            return cell
        }
            
            // 보노 가맹점 신청 -> 계좌번호 셀
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopAccountNumCell") as! ShopAccountNumCell
            return cell
        }
            
            // 보노 가맹점 신청 -> 휴대폰번호 셀
        else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopPhoneNumCell") as! ShopPhoneNumCell
            return cell
        }
            
            // 보노 가맹점 신청 -> 사업장 주소 셀
        else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopAddressCell") as! ShopAddressCell
            return cell
        }
            
            // 보노 가맹점 신청 -> 기업소개 셀
        else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCompanyInfoCell") as! ShopCompanyInfoCell
            return cell
        }
            
            // 보노 가맹점 신청 -> 가맹점신청구분 셀
        else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopApplyDivisionCell") as! ShopApplyDivisionCell
            return cell
        }
            
            
            // 보노 가맹점 신청 -> 가맹점신청구분 셀
        else if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopApplyHomePageCell") as! ShopApplyHomePageCell
            return cell
        }
            // 회원가입 -> 회원정보 수정 완료 셀
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopApplyCompleteCell") as! ShopApplyCompleteCell
            
            cell.delegate = self
            
            return cell
        }
    }
    
    func shopBankNameCellProtocol(shopBankNameCellProtocol: ShopBankNameCell) {
        print("//---------->    은행선택 얼럿  <----------//")
        let contentVC = ShopApplyRealBankListTableVC()
        contentVC.delegate = self
        // 경고창 객체를 생성하고, OK 및 Cancel 버튼을 추가한다.
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: .alert)
        
        // 컨트롤 뷰 컨트롤러를 알림창에 등록한다.
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        
        let okAction = UIAlertAction(title: "확인", style: .default){
            UIAlertAction in
            DispatchQueue.main.async {
                self.shopApplyTV.reloadData()
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: false)
    }
    
    func shopApplyCompleteCell(shopApplyCompleteCell: ShopApplyCompleteCell) {
        
        print("//---------->    회원정보수정 submit    <----------//")
        let alertTitle = "원페이"
        var alertMessage = ""
        
        let shopApply_Complete_result = Data_ShopApply.shared.shopApply_Complete_result
        
        switch shopApply_Complete_result {
            
        case "1" :
            alertMessage = "신청인 이름을 입력해주세요."
        case "2" :
            alertMessage = "기업명을 입력해주세요."
        case "3" :
            alertMessage = "사업자등록번호 or 주민등록번호를 입력해주세요."
        case "4" :
            alertMessage = "은행을 선택해주세요."
        case "5" :
            alertMessage = "예금주명을 입력해주세요."
        case "6" :
            alertMessage = "계좌번호를 입력해주세요."
        case "7" :
            alertMessage = "연락처를 입력해주세요."
        case "8" :
            alertMessage = "회사주소를 입력해주세요.(최대 100자)"
        case "9" :
            alertMessage = "회사소개를 입력해주세요.(최대 1000자)"
        case "10" :
            alertMessage = "온/오프라인 샵을 선택해주세요.."
        default:
            alertMessage = "가맹점신청 실패"
        }
        
        if shopApply_Complete_result == "success" {
            alertMessage = "가맹점신청 성공"
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            
            if shopApply_Complete_result == "success" {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
        }
        
        alert.addAction(ok)
        self.present(alert, animated: false)    }
    
}
