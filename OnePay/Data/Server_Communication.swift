//
//  Server_Communication.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 5. 29..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
let serviceUrl = UrlData()


class ServerTrans_MemberInfoLoad {
    static let shared: ServerTrans_MemberInfoLoad = ServerTrans_MemberInfoLoad()
    
    // 회원 정보 조회
    func loginMemberInfoLoad() {
        let member_srl = Data_MemberInfo.shared.member_srl
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/memberInfo"
            let param: Parameters = [
                "member_srl": member_srl
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        let memberInfo = (jsonObject["memberInfo"]!) as? [String: Any]
                        print("💚💚💚💚💚💚💚💚💚💚💚💚💚💚")
                        
                        guard let user_id = memberInfo!["user_id"] else { return }
                        guard let eng_name = memberInfo!["eng_name"] else { return }
                        guard let user_name = memberInfo!["user_name"] else { return }
                        guard let user_nation = memberInfo!["user_nation"] else { return }
                        guard let user_birth = memberInfo!["user_birth"] else { return }
                        guard let user_gender = memberInfo!["user_gender"] else { return }
                        guard let user_email = memberInfo!["user_email"] else { return }
                        guard let user_phone = memberInfo!["user_phone"] else { return }
                        guard let push_id = memberInfo!["push_id"] else { return }
                        guard let mall_yn = memberInfo!["mall_yn"] else { return }
                        guard let push_change = memberInfo!["push_change"] else { return }
                        guard let real_bank_code = memberInfo!["real_bank_code"] else { return }
                        guard let real_acc_no = memberInfo!["real_acc_no"] else { return }
                        guard let branch = memberInfo!["branch"] else { return }
                        guard let bank_code = memberInfo!["bank_code"] else { return }
                        guard let acc_no = memberInfo!["acc_no"] else { return }
                        guard let fcm_key = memberInfo!["fcm_key"] else { return }
                        guard let pay_password = memberInfo!["pay_password"] else { return }
                        
                        /*
                         member_srl = 회원 고유번호
                         user_id = 회원 아이디
                         eng_name = 회원 영문이름
                         user_name = 회원 한글이름
                         user_nation = 회원 국적
                         user_birth = 회원 생년원일
                         user_gender = 회원 성별
                         user_email = 회원 이메일
                         user_phone = 회원 휴대폰번호
                         push_id = 회원 추천인아이디
                         mall_yn = 쇼핑몰 신청 여부
                         push_change = 추천인 변경
                         card_no = 회원 카드번호
                         exp_date = 회원 카드 유효기간
                         branch = 지점명
                         bank_code = 은행코드
                         acc_no = 가상계좌번호
                         fcm_key = fcm 인증키
                         pay_password = 가상계좌 결제비밀번호
                         */
                        
                        
                        
                        // json null 값 처리
                        
                        if user_id is NSNull {
                            Data_MemberInfo.shared.user_id = ""
                        } else {
                            Data_MemberInfo.shared.user_id = "\(user_id)"
                        }
                        
                        if eng_name is NSNull {
                            Data_MemberInfo.shared.eng_name = ""
                        } else {
                            Data_MemberInfo.shared.eng_name = "\(eng_name)"
                        }
                        
                        if user_name is NSNull {
                            Data_MemberInfo.shared.user_name = ""
                        } else {
                            Data_MemberInfo.shared.user_name = "\(user_name)"
                        }
                        
                        if user_nation is NSNull {
                            Data_MemberInfo.shared.user_nation = ""
                        } else {
                            Data_MemberInfo.shared.user_nation = "\(user_nation)"
                        }
                        
                        
                        if user_birth is NSNull {
                            Data_MemberInfo.shared.user_birth = ""
                        } else {
                            Data_MemberInfo.shared.user_birth = "\(user_birth)"
                        }
                        
                        if user_gender is NSNull {
                            Data_MemberInfo.shared.user_gender = ""
                        } else {
                            Data_MemberInfo.shared.user_gender = "\(user_gender)"
                        }
                        
                        if user_email is NSNull {
                            Data_MemberInfo.shared.user_email = ""
                        } else {
                            Data_MemberInfo.shared.user_email = "\(user_email)"
                        }
                        
                        if user_phone is NSNull {
                            Data_MemberInfo.shared.user_phone = ""
                        } else {
                            Data_MemberInfo.shared.user_phone = "\(user_phone)"
                        }
                        
                        if push_id is NSNull {
                            Data_MemberInfo.shared.push_id = ""
                        } else {
                            Data_MemberInfo.shared.push_id = "\(push_id)"
                        }
                        
                        if mall_yn is NSNull {
                            Data_MemberInfo.shared.mall_yn = ""
                        } else {
                            Data_MemberInfo.shared.mall_yn = "\(mall_yn)"
                        }
                        
                        if push_change is NSNull {
                            Data_MemberInfo.shared.push_change = ""
                        } else {
                            Data_MemberInfo.shared.push_change = "\(push_change)"
                        }
                        
                        if real_bank_code is NSNull {
                            Data_MemberInfo.shared.real_bank_code = ""
                        } else {
                            Data_MemberInfo.shared.real_bank_code = "\(real_bank_code)"
                        }
                        
                        if real_acc_no is NSNull {
                            Data_MemberInfo.shared.real_acc_no = ""
                        } else {
                            Data_MemberInfo.shared.real_acc_no = "\(real_acc_no)"
                        }
                        
                        if branch is NSNull {
                            Data_MemberInfo.shared.branch = ""
                        } else {
                            Data_MemberInfo.shared.branch = "\(branch)"
                        }
                        
                        if bank_code is NSNull{
                            Data_MemberInfo.shared.bank_code = ""
                        } else {
                            Data_MemberInfo.shared.bank_code = "\(bank_code)"
                        }
                        
                        if acc_no is NSNull {
                            Data_MemberInfo.shared.acc_no = ""
                        } else {
                            Data_MemberInfo.shared.acc_no = "\(acc_no)"
                        }
                        
                        if fcm_key is NSNull{
                            Data_MemberInfo.shared.fcm_key = ""
                        } else {
                            Data_MemberInfo.shared.fcm_key = "\(fcm_key)"
                        }
                        
                        if pay_password is NSNull{
                            Data_MemberInfo.shared.pay_password = ""
                        } else {
                            Data_MemberInfo.shared.pay_password = "\(pay_password)"
                        }
                        
                        print("정보조회 2")
                        print("member_srl = " + "\(member_srl)")
                        print("user_id = " + "\(user_id)")
                        print("eng_name = " + "\(eng_name)")
                        print("user_name = " + "\(user_name)")
                        print("user_nation = " + "\(user_nation)")
                        print("user_birth = " + "\(user_birth)")
                        print("user_gender = " + "\(user_gender)")
                        print("user_email = " + "\(user_email)")
                        print("user_phone = " + "\(user_phone)")
                        print("push_id = " + "\(push_id)")
                        print("mall_yn = " + "\(mall_yn)")
                        print("push_change = " + "\(push_change)")
                        print("real_bank_code = " + "\(real_bank_code)")
                        print("real_acc_no = " + "\(real_acc_no)")
                        print("branch = " + "\(branch)")
                        print("bank_code = " + "\(bank_code)")
                        print("acc_no = " + "\(acc_no)")
                        print("fcm_key = " + "\(fcm_key)")
                        print("pay_password = " + "\(pay_password)")
                        print("회원정보 로드 성공")
                        
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
}

// 회원 자산 조회
class ServerTrans_AssetDataLoad {
    static let shared: ServerTrans_AssetDataLoad = ServerTrans_AssetDataLoad()
    
    func memberAssetDataLoad() {
        print("회원 자산조회시작")
        let member_srl = Data_MemberInfo.shared.member_srl
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/memberAsset"
            let param: Parameters = [
                "member_srl": member_srl
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        print("회원 자산조회성공")
                        let memberInfo = (jsonObject["memberAsset"]!) as? [String: Any]
                        
                        guard let member_srl = memberInfo!["member_srl"] else { return }
                        guard let cash_bal = memberInfo!["cash_bal"] else { return }
                        guard let dum_bal = memberInfo!["dum_bal"] else { return }
                        guard let cashable_dum = memberInfo!["cashable_dum"] else { return }
                        guard let ins_date = memberInfo!["ins_date"] else { return }
                        guard let mod_date = memberInfo!["mod_date"] else { return }
                        guard let acc_no = memberInfo!["acc_no"] else { return }
                        /*
                         member_srl     =   회원고유 번호
                         acc_no         =   가상계좌 번호
                         cash_bal       =   포인트 잔액
                         dum_bal        =   덤 잔액
                         cashable_dum   =   포인트 전환 가능 덤 잔액
                         ins_date       =   insert date
                         mod_date       =   modify date
                         */
                        
                        // json 응답 null 값 처리
                        if member_srl is NSNull {
                            Data_MemberAsset.shared.member_srl = ""
                        } else {
                            Data_MemberAsset.shared.member_srl = "\(member_srl)"
                        }
                        
                        if cash_bal is NSNull {
                            Data_MemberAsset.shared.cash_bal = ""
                        } else {
                            Data_MemberAsset.shared.cash_bal = "\(cash_bal)"
                        }
                        
                        if dum_bal is NSNull{
                            Data_MemberAsset.shared.dum_bal = ""
                        } else {
                            Data_MemberAsset.shared.dum_bal = "\(dum_bal)"
                        }
                        
                        if cashable_dum is NSNull{
                            Data_MemberAsset.shared.cashable_dum = ""
                        } else {
                            Data_MemberAsset.shared.cashable_dum = "\(cashable_dum)"
                        }
                        
                        if ins_date is NSNull{
                            Data_MemberAsset.shared.ins_date = ""
                        } else {
                            Data_MemberAsset.shared.ins_date = "\(ins_date)"
                        }
                        
                        if mod_date is NSNull{
                            Data_MemberAsset.shared.mod_date = ""
                        } else {
                            Data_MemberAsset.shared.mod_date = "\(mod_date)"
                        }
                        
                        if acc_no is NSNull{
                            Data_MemberAsset.shared.acc_no = ""
                        } else {
                            Data_MemberAsset.shared.acc_no = "\(acc_no)"
                        }
                        
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
}

// Fcm Key 등록
class ServerTrans_RegistFcmKey {
    static let shared: ServerTrans_RegistFcmKey = ServerTrans_RegistFcmKey()
    
    // FcmKey 등록
    func registFcmKeySend() {
        let member_srl = Data_MemberInfo.shared.member_srl
        let fcm_key = Data_Default.shared.new_FcmToken
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/registFcmKey"
            let param: Parameters = [
                "member_srl": member_srl,
                "fcm_key": fcm_key
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        print("fcm key 등록 성공")
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        print("fcm key 등록 실패")
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
}

// FcmKey 등록 해제
class ServerTrans_UnRegistFcmKey {
    static let shared: ServerTrans_RegistFcmKey = ServerTrans_RegistFcmKey()
    
    func unregistFcmKeySend() {
        print("FcmKey 해제 시작")
        let member_srl = Data_MemberInfo.shared.member_srl
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/unregistFcmKey"
            let param: Parameters = [
                "member_srl": member_srl
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        print("fcm key 해제 성공")
                        self.resetDefaults()
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        print("fcm key 해제 실패")
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    func resetDefaults() {
        let ud = UserDefaults.standard
        print("임시 저장 값 삭제")
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        ud.set("", forKey: "Auto_Login_user_id")
        ud.set("", forKey: "Auto_Login_user_password")
        ud.set("", forKey: "Auto_Login_Result")
        ud.set("", forKey: "Auto_Login_member_srl")
    }
}

class ServerTrans_FeesPayDataLoad {
    static let shared: ServerTrans_FeesPayDataLoad = ServerTrans_FeesPayDataLoad()
    
    
    
    // 이용료 납부 내역 조회
    func feesPayDataLoad(){
        let member_srl = Data_MemberInfo.shared.member_srl
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/checkDues"
            let param: Parameters = [
                "member_srl": member_srl
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                
                if let jsonObject = response.result.value as? [String: Any] {
                    
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        
                        guard let duesAmount = jsonObject["duesAmount"] else { return }
                        guard let exDate = jsonObject["exDate"] else { return }
                        
                        // json 응답 null 값 처리
                        if duesAmount is NSNull {
                            Data_FeesPay.shared.duesAmount = ""
                        } else {
                            Data_FeesPay.shared.duesAmount = "\(duesAmount)"
                        }
                        
                        if exDate is NSNull {
                            Data_FeesPay.shared.exDate = ""
                        } else {
                            Data_FeesPay.shared.exDate = "\(exDate)"
                        }
                        
                        /*
                         duesAmount     =   월 이용료
                         exDate         =   납부완료상태일 때 유효기간 ex)201805
                         */
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        Data_FeesPay.shared.duesAmount = ""
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
}


