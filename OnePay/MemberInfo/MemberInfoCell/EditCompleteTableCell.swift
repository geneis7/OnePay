//
//  EditCompleteTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SCrypto

protocol EditCompleteTableCellProtocol {
    func editCompleteTableCellProtocol(editCompleteTableCellProtocol:EditCompleteTableCell)
}

class EditCompleteTableCell: UITableViewCell {
    let serviceUrl = UrlData()
    var delegate:EditCompleteTableCellProtocol?
    var password:String = ""
    var npassword:String = ""
    var push_id:String = ""
    var push_change:String = ""
    @IBOutlet weak var btn_editCommit: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_editCommit.layer.cornerRadius = 10
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // 회원정보 수정하기
    @IBAction func editCompleteBtn(_ sender: Any) {
        
        Data_MemberInfo_Edit.shared.edit_Submit_ResultCode = "fail"
        
        // 새로운 회원정보
        let edit_PassCheck1 = Data_MemberInfo_Edit.shared.edit_PassCheck1
        let edit_PassCheck2 = Data_MemberInfo_Edit.shared.edit_PassCheck2
        let edit_password = Data_MemberInfo_Edit.shared.edit_password
        let edit_ConfirmPassCheck1 = Data_MemberInfo_Edit.shared.edit_Confirm_PassCheck1
        let edit_ConfirmPassCheck2 = Data_MemberInfo_Edit.shared.edit_Confirm_PassCheck2
        let edit_ConfirmPass = Data_MemberInfo_Edit.shared.edit_Confirm_password
        let edit_push_id = Data_MemberInfo_Edit.shared.edit_Push_Id
        let edit_push_id_result = Data_MemberInfo_Edit.shared.edit_Push_Id_Result
        
        // 기존 회원 정보
        
        let member_srl = Data_MemberInfo.shared.member_srl
        let origin_push_id = Data_MemberInfo.shared.push_id
        let origin_push_change = Data_MemberInfo.shared.push_change
        let origin_password = Data_MemberInfo_Edit.shared.edit_password
        
//        if origin_password == nil || origin_password == "" {
//            origin_password = edit.text?.SHA256()
//        }
        
        // 회원정보수정 유효성 검증
        do {
            if edit_PassCheck1 == "false" || edit_PassCheck2 == "true"{
                Data_MemberInfo_Edit.shared.editAlertResultCode = "0"
            } else if edit_ConfirmPassCheck1 == "false" || edit_ConfirmPassCheck2 == "true" {
                Data_MemberInfo_Edit.shared.editAlertResultCode = "1"
            }  else {
                Data_MemberInfo_Edit.shared.editAlertResultCode = "100"
            }
            
            if Int(Data_MemberInfo_Edit.shared.editAlertResultCode)! < 100 {
                self.delegate?.editCompleteTableCellProtocol(editCompleteTableCellProtocol: self)
            }
            
        }
        
        if Data_MemberInfo_Edit.shared.editAlertResultCode == "100" {
            
            // 서버로보낼 데이터 지정
            if edit_password == "" && edit_ConfirmPass == "" {
                password = origin_password
                npassword = origin_password
            }
            
            if edit_password != "" && edit_ConfirmPass != "" {
                password = edit_password
                npassword = edit_ConfirmPass
            }
            
            
            
            if origin_push_change == "N" {
                push_id = origin_push_id
                push_change = "N"
            }
            
            if origin_push_change == "Y" {
                
                if edit_push_id != "" && edit_push_id_result == "success" {
                    push_id = edit_push_id
                    push_change = "N"
                } else if edit_push_id != "" && edit_push_id_result != "success" {
                    push_id = origin_push_id
                    push_change = "Y"
                } else if edit_push_id == "" && edit_push_id_result == "success" {
                    push_id = origin_push_id
                    push_change = "Y"
                } else if edit_push_id == "" && edit_push_id_result != "success" {
                    push_id = origin_push_id
                    push_change = "Y"
                } else {
                    push_id = origin_push_id
                    push_change = "Y"
                }
            }

            print("정보수정 최종 데이터::::::::::::::::::::::::")
            print("edit_PassCheck1 = " + "\(edit_PassCheck1)")
            print("edit_PassCheck2 = " + "\(edit_PassCheck2)")
            print("edit_password = " + "\(edit_password)")
            print("edit_ConfirmPassCheck1 = " + "\(edit_ConfirmPassCheck1)")
            print("edit_ConfirmPassCheck2 = " + "\(edit_ConfirmPassCheck2)")
            print("edit_ConfirmPass = " + "\(edit_ConfirmPass)")
            print("edit_push_id = " + "\(edit_push_id_result)")
            print("member_srl = " + "\(member_srl)")
            print("origin_push_change = " + "\(origin_push_change)")
            print("member_srl = " + "\(member_srl)")
            print("origin_password = " + "\(origin_password)")
            print("정보수정 최종 데이터::::::::::::::::::::::::")

            do {
                let url = serviceUrl.realServiceUrl + "/onepay/rest/memberModify"
                let param: Parameters = [
                    "member_srl": member_srl,
                    "password": edit_password,
                    "npassword": npassword,
                    "push_id": push_id,
                    "push_change": push_change
                ]
                
                print("//---------->    회원정보수정 submit 정보   <----------//")
                print("member_srl = " + "\(member_srl)")
                print("password = " + "\(origin_password)")
                print("npassword = " + "\(npassword)")
                print("push_id = " + "\(push_id)")
                print("push_change = " + "\(push_change)")
                
                let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
                alamo.responseJSON() { response in
                    if let jsonObject = response.result.value as? [String: Any] {
                        if String(describing: (jsonObject["resultCode"]!)) == "1" {
                            print("//---------->    회원정보수정 성공  <----------//")
                            ServerTrans_MemberInfoLoad.shared.loginMemberInfoLoad()
                            Data_MemberInfo_Edit.shared.edit_Submit_ResultCode = "success"
                        } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                            print("//---------->    회원정보수정 실패  <----------//")
                            Data_MemberInfo_Edit.shared.edit_Submit_ResultCode = "fail"
                        } else {
                            print("회원정보수정 실패")
                            Data_MemberInfo_Edit.shared.edit_Submit_ResultCode = "fail"
                        }
                        self.delegate?.editCompleteTableCellProtocol(editCompleteTableCellProtocol: self)
                        print("resultCode = \(jsonObject["resultCode"]!)")
                        print("resultMessage = \(jsonObject["resultMessage"]!)")
                    }
                }
            }
        }
    }
}
