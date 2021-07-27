//
//  MemberInfoVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 9..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MemberInfoVC: UIViewController,UITableViewDelegate,UITableViewDataSource,RecommenderIdCheckProtocol,EditRecommendationForMeListCellProtocol,EditCompleteTableCellProtocol {
    
    @IBOutlet weak var editMemberInfoTV: UITableView!
    
    let serviceUrl = UrlData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)


        
        
        ServerTrans_MemberInfoLoad.shared.loginMemberInfoLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        
        editMemberInfoTV.delegate = self
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 셀 로우 섹션 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    // 각각의 셀 커스텀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 회원정보수정 -> 아이디 셀
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditIdTableCell") as! EditIdTableCell
            
            return cell
        }
            
            // 회원정보수정 -> 비밀번호 셀
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditPassTableCell") as! EditPassTableCell
            
            return cell
        }
            
            // 회원정보수정 -> 비밀번호 재확인 셀
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditConfirmPassTableCell") as! EditConfirmPassTableCell
            return cell
        }
            
            // 회원정보수정 ->  한글 이름 셀
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditKorNameTableCell") as! EditKorNameTableCell
            return cell
        }
            
            // 회원정보수정 ->  영어 이름 셀
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditEngNameTableCell") as! EditEngNameTableCell
            return cell
        }
            
            // 회원정보수정 -> 지점명 셀
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditBranchNameTableCell") as! EditBranchNameTableCell
            return cell
        }
            
            // 회원정보수정 ->  국적 셀
        else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCountryTableCell") as! EditCountryTableCell
            return cell
        }
            
            // 회원정보수정 -> 생년월일 셀
        else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditDateOfBirthTableCell") as! EditDateOfBirthTableCell
            return cell
        }
            
            // 회원정보수정 ->  성별 셀
        else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditGenderTableCell") as! EditGenderTableCell
            return cell
        }
            
            // 회원정보수정 -> 이메일주소 셀
        else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditEmailTableCell") as! EditEmailTableCell
            return cell
        }
            
            // 회원정보수정 -> 휴대폰번호 셀
        else if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditPhoneNumberTableCell") as! EditPhoneNumberTableCell
            return cell
        }
            
            // 회원정보수정 -> 추천인 아이디 셀
        else if indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditRecommenderIdTableCell") as! EditRecommenderIdTableCell
            cell.delegate = self
            return cell
        }
    
            // 회원가입 -> 추천인 리스트 셀
        else if indexPath.row == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditRecommendationForMeListCell") as! EditRecommendationForMeListCell
            
            cell.delegate = self
            
            return cell
        }
            
            // 회원가입 -> 회원정보 수정 완료 셀
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCompleteTableCell") as! EditCompleteTableCell
            
            cell.delegate = self
            
            return cell
        }
    }
    
    // 셀 선택할때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.editMemberInfoTV.reloadData()
        }
    }
    
    // 키보드 화면 업
    @objc func keyboardWillShow(_ sender: Notification) {
        let indexPathNum = Data_MemberInfo_Edit.shared.memberInfoIndexPath
        let info = sender.userInfo
        let kbSize: CGSize? = (info?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size
        var bkgndRect: CGRect = view.frame
        bkgndRect.size.height -= (kbSize?.height)!

        if indexPathNum == "up" {
            self.view.frame.origin.y -= (kbSize?.height)!
        }
    }
    
    // 키보드 화면 다운
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
        Data_Default.shared.IndexPathNum = ""
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func recommenderIdCheck(recommenderIdCheck: EditRecommenderIdTableCell) {
        let edit_push_id_result = Data_MemberInfo_Edit.shared.edit_Push_Id_Result
        let edit_push_id = Data_MemberInfo_Edit.shared.edit_Push_Id
        let origin_push_id = Data_MemberInfo.shared.push_id
            var alertTitle = ""
            var alertMessage = ""
            
            if edit_push_id_result == "fail" {
                alertTitle = "추천인 변경 실패"
                alertMessage = "추천인을 다시 확인해주세요."
            } else if edit_push_id_result == "success" && edit_push_id == origin_push_id {
                alertTitle = "기존의 추천인 입니다."
                alertMessage = "추천인을 다시 확인해 주세요."
            } else if edit_push_id_result == "success" && edit_push_id != "" {
                alertTitle = "추천인 변경 가능"
                alertMessage = "추천인은 '한번만' 변경가능합니다."
            }
        
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
                DispatchQueue.main.async {
                    self.editMemberInfoTV.reloadData()
                }
            }
            
            alert.addAction(ok)
            self.present(alert, animated: false)
    }
    

    
    
    func editRecommendationForMeListCellProtocol(editRecommendationForMeListCellProtocol: EditRecommendationForMeListCell) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "EditRecommenderListStoryID")
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }

    
    func editCompleteTableCellProtocol(editCompleteTableCellProtocol: EditCompleteTableCell) {
        
        print("//---------->    회원정보수정 submit    <----------//")
        let alertTitle = "원페이"
        var alertMessage = ""
        let editAlertResultCode = Data_MemberInfo_Edit.shared.editAlertResultCode
        let edit_Submit_ResultCode = Data_MemberInfo_Edit.shared.edit_Submit_ResultCode

        switch editAlertResultCode {
        case "0" :
            alertMessage = "비밀번호 6-15자리, 영문+숫자 조합을 확인해주세요.(특수X)"
        case "1" :
            alertMessage = "비밀번호확인 6-15자리, 영문+숫자 조합을 확인해주세요.(특수X)"
        case "2" :
            alertMessage = "비밀번호 재 확인이 일치 하지 않습니다."
        case "3" :
            alertMessage = "은행을 선택해주세요."
        case "4" :
            alertMessage = "계좌번호를 입력해주세요."
        case "5" :
            alertMessage = "은행과 계좌번호를 확인해주세요."
        case "6" :
            alertMessage = "계좌확인을 해주세요."
        case "7" :
            alertMessage = "계좌확인을 해주세요."
        case "8" :
            alertMessage = "계좌확인을 해주세요."
        case "9" :
            alertMessage = "계좌확인을 해주세요."
        case "10" :
            alertMessage = "계좌확인을 해주세요."
        default:
            alertMessage = "회원정보수정 실패"
        }
        
        if edit_Submit_ResultCode == "success" {
            alertMessage = "회원정보수정 성공"
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            
            if edit_Submit_ResultCode == "success" {
                ServerTrans_MemberInfoLoad.shared.loginMemberInfoLoad()
                DispatchQueue.main.async {
                    self.editMemberInfoTV.reloadData()
                }
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
        }
        
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
}

