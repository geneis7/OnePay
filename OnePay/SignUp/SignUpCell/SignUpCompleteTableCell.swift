//
//  SignUpCompleteTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol ResultProtocol {
    func signUpComplete(signUpComplete:SignUpCompleteTableCell)
}


// 회원가입 -> 회원가입 완료 셀
class SignUpCompleteTableCell:UITableViewCell {
    
    @IBOutlet weak var btn_SignUpComeplete: UIButton!
    var delegate:ResultProtocol?
    let serviceUrl = UrlData()
    
    let site_gb = "IOS"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btn_SignUpComeplete.layer.cornerRadius = 10
        
    }
    
    @IBAction func signUpCompleteBtn(_ sender: UIButton) {
        let phoneAuthResult = Data_SignUp.shared.signUp_PhoneAuthResult
        let user_id = Data_SignUp.shared.signUp_User_Id
        let password = Data_SignUp.shared.signUp_Password
        let user_name = Data_SignUp.shared.signUp_User_Name
        let eng_name = Data_SignUp.shared.signUp_User_EngName
        let branch = Data_SignUp.shared.signUp_Select_Branch_Code
        var user_nation = Data_SignUp.shared.signUp_User_Nation_Code
        let user_birth = Data_SignUp.shared.signUp_User_Birth
        let user_gender = Data_SignUp.shared.signUp_User_Gender
        let user_email = Data_SignUp.shared.signUp_User_Email
        let user_phone = Data_SignUp.shared.signUp_User_PhoneNumber
        let push_id = Data_SignUp.shared.signUp_User_PushId
        if phoneAuthResult != "success"{
            self.delegate?.signUpComplete(signUpComplete: self)
            return
        }
        if user_nation != "" {
            user_nation = "KR"
        }
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/memberJoin"
            let param: Parameters = [
                "user_id": user_id,
                "password": password,
                "user_name": user_name,
                "eng_name": eng_name,
                "branch": branch,
                "user_nation": user_nation,
                "user_birth": user_birth,
                "user_gender": user_gender,
                "user_email": user_email,
                "user_phone": user_phone,
                "push_id": push_id,
                "site_gb": site_gb
            ]
            print("user_id =" + "\(user_id)")
            print("password =" + "\(password)")
            print("user_name =" + "\(user_name)")
            print("eng_name =" + "\(eng_name)")
            print("branch =" + "\(branch)")
            print("user_nation =" + "\(user_nation)")
            print("user_birth =" + "\(user_birth)")
            print("user_gender =" + "\(user_gender)")
            print("user_email =" + "\(user_email)")
            print("user_phone =" + "\(user_phone)")
            print("push_id =" + "\(push_id)")
            print("site_gb =" + "\(site_gb)")
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                print("JSON=\(response.result.value!)")
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        print("//---------->    회원가입 성공  <----------//")
                        Data_SignUp.shared.signUp_Success_Result = "success"
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        Data_SignUp.shared.signUp_Success_Result = "fail"
                        print("//---------->    회원가입 실패  <----------//")
                    } else {
                        Data_SignUp.shared.signUp_Success_Result = "fail"
                        print("//---------->    회원가입 실패  <----------//")
                    }
                    self.delegate?.signUpComplete(signUpComplete: self)
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    // 가입정보 임시저장 값 삭제
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}





 
