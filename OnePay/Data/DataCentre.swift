//
//  DataCentre.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 5. 14..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// 기본 데이터
class Data_Default {
    static let shared: Data_Default = Data_Default()
    var device_WidthSize:String = ""
    var slideCellMainGotoValue:String = ""
    var IndexPathNum:String = ""
    var new_FcmToken:String = ""
}

// 회원정보
class Data_MemberInfo {
    static let shared: Data_MemberInfo = Data_MemberInfo()
    
    var member_srl:String = ""
    var user_id:String = ""
    var eng_name:String = ""
    var user_name:String = ""
    var user_nation:String = ""
    var user_birth:String = ""
    var user_gender:String = ""
    var user_email:String = ""
    var user_phone:String = ""
    var push_id:String = ""
    var mall_yn:String = ""
    var push_change:String = ""
    var real_bank_code:String = ""
    var real_acc_no:String = ""
    var branch:String = ""
    var bank_code:String = ""
    var acc_no:String = ""
    var fcm_key:String = ""
    var pay_password:String = ""
    var origin_password:String = ""
}

// 회원 자산
class Data_MemberAsset {
    static let shared: Data_MemberAsset = Data_MemberAsset()
    var member_srl:String = ""
    var cash_bal:String = ""
    var dum_bal:String = ""
    var cashable_dum:String = ""
    var ins_date:String = ""
    var mod_date:String = ""
    var acc_no:String = ""
}

// 은행 정보
class Data_BankInfo {
    static let shared: Data_BankInfo = Data_BankInfo()
    var bankSorted = [String:String]()
    var bankSorted_Name = [String:String]()
    var bankSorted_Code = [String:String]()
    var bankListSeq:[String] = []
    var bankListName:[String] = []
    var bankListCode:[String] = []
    var selectBankName:String = ""
    var selectBankCode:String = ""
}

// 큐알 코드 결제
class Data_QRCode {
    static let shared: Data_QRCode = Data_QRCode()
    var qrcode_type:String = ""
    var qrcode_mallName:String = ""
    var qrcode_shopSrl:String = ""
    var qrcode_orderNumber:String = ""
    var qrcode_productName:String = ""
    var qrcode_returnUrl:String = ""
    var qrcode_totalAmount:String = ""
}

// 이용료 납부
class Data_FeesPay {
    static let shared: Data_FeesPay = Data_FeesPay()
    var duesAmount:String = ""
    var exDate:String = ""

}

// 달력
class Data_Calendar {
    static let shared: Data_Calendar = Data_Calendar()
    var current_Date:String = ""
    var start_day:String = ""
    var end_day:String = ""
    
}

// 포인트 송금
class Data_SendMoney {
    static let shared: Data_SendMoney = Data_SendMoney()
    var sendMoney_Flag:String = ""
    var sendMoney_Member_srl:String = ""
    var sendMoney_TotalAmount:String = ""
    var sendMoney_CashAmount:String = ""
    var sendMoney_OutName:String = ""
    var sendMoney_InBankCode:String = ""
    var sendMoney_InBankCode2:String = ""
    var sendMoney_InAccNo:String = ""
    var sendMoney_InName:String = ""
    var sendMoney_Fee:String = ""
    
}

// 가맹점 리스트
class Data_ShopList {
    static let shared: Data_ShopList = Data_ShopList()
    var shopList_Image:[String] = []
    var shopList_Url:[String] = []
    
}

// 결제 비밀번호
class Data_PaymentPassword {
    static let shared: Data_PaymentPassword = Data_PaymentPassword()
    var regist_PaymentPassword:String = ""
}

// 가맹점 신청
class Data_ShopApply {
    static let shared: Data_ShopApply = Data_ShopApply()
    var shopApply_Name:String = ""
    var shopApply_HomePage:String = ""
    var shopApply_Division:String = ""
    var shopApply_CompanyInfo:String = ""
    var shopApply_Address:String = ""
    var shopApply_PhoneNumber:String = ""
    var shopApply_AccountNumber:String = ""
    var shopApply_AccountHolder:String = ""
    var shopApply_BusinessNum:String = ""
    var shopApply_IndexPathNum:String = ""
    var shopApply_Company_Name:String = ""
    var shopApply_Select_BankName:String = ""
    var shopApply_Select_BankCode:String = ""
    var shopApply_Complete_result:String = ""
}

// 회원정보 수정
class Data_MemberInfo_Edit {
    static let shared: Data_MemberInfo_Edit = Data_MemberInfo_Edit()
    var edit_PassCheck1:String = ""
    var edit_PassCheck2:String = ""
    var edit_password:String = ""
    var edit_Confirm_PassCheck1:String = ""
    var edit_Confirm_PassCheck2:String = ""
    var edit_Confirm_password:String = ""
    var branch_Code:[String] = []
    var branch_Name:[String] = []
    var branch_List = [String:String]()
    var edit_Push_Id:String = ""
    var edit_Push_Id_Result:String = ""
    var memberInfoIndexPath:String = ""
    var editAlertResultCode:String = ""
    var edit_Submit_ResultCode:String = ""
}

// 회원가입
class Data_SignUp {
    static let shared: Data_SignUp = Data_SignUp()
    var signUp_PhoneAuthResult:String = ""
    var signUp_User_Id:String = ""
    var signUp_User_Name:String = ""
    var signUp_User_EngName:String = ""
    var signUp_Select_Branch_Name:String = ""
    var signUp_Select_Branch_Code:String = ""
    var signUp_branch_Code:[String] = []
    var signUp_branch_Name:[String] = []
    var signUp_branch_List = [String:String]()
    var signUp_User_Nation:String = ""
    var signUp_User_Nation_Name:String = ""
    var signUp_User_Nation_Code:String = ""
    var signUp_User_Birth:String = ""
    var signUp_User_Gender:String = ""
    var signUp_User_Email:String = ""
    var signUp_User_PhoneNumber:String = ""
    var signUp_User_PhoneNumber_Result:String = ""
    var signUp_User_PushId:String = ""
    var signUp_User_PushId_Result:String = ""
    var signUp_Success_Result:String = ""
    var signUp_PassCheck1:String = ""
    var signUp_PassCheck2:String = ""
    var signUp_Password:String = ""
    var signUp_Confirm_PassCheck1:String = ""
    var signUp_Confirm_PassCheck2:String = ""
    var signUp_Confirm_Password:String = ""
    var signUp_IdStrCheckResult:String = ""
    var signUp_IdCheckResult:String = ""
}

// 스마트콘
class Data_SmartCon {
    static let shared: Data_SmartCon = Data_SmartCon()
    var smartCon_EventId:String = ""
    var smartCon_cate_name:[String] = []
    var smartCon_cate_code:[String] = []
    var smartCon_icon_url:[String] = []
    var smartCon_brand_Total_Array:[String] = []
    var smartCon_brand_name_array = [String : [String]]()
    var smartCon_brand_code_array = [String : [String]]()
    var smartCon_brand_cate_code_array = [String : [String]]()
    var smartCon_brand_img_array = [String : [String]]()
    var smartCon_SelectBrandImageIndex:String = ""
    var smartCon_SelectBrandData:[String] = []
    var smartCon_SelectGoodsInfo:[String] = []

    
}

// 스마트콘 - 나의쿠폰
class Data_SmartCon_MyCon {
    static let shared: Data_SmartCon_MyCon = Data_SmartCon_MyCon()
    var myCon_tr_id_array:[String] = []
    var myCon_member_srl_array:[String] = []
    var myCon_event_id_array:[String] = []
    var myCon_goods_id_array:[String] = []
    var myCon_disc_price_array:[String] = []
    var myCon_disc_rate_array:[String] = []
    var myCon_price_array:[String] = []
    var myCon_order_cnt_array:[String] = []
    var myCon_img_url_array:[String] = []
    var myCon_exchange_status_array:[String] = []
    var myCon_goods_name_array:[String] = []
    var myCon_brand_name_array:[String] = []
    var myCon_total_cnt:String = ""
}

// 스마트콘 - 나의 쿠폰 실시간 조회
class Data_SmartCon_MyCon_Vali {
    static let shared: Data_SmartCon_MyCon_Vali = Data_SmartCon_MyCon_Vali()
    var myCon_Vali_claim_type:[String] = []
    var myCon_Vali_valid_start:[String] = []
    var myCon_Vali_valid_end:[String] = []
    var myCon_Vali_tr_id:[String] = []
    var myCon_Vali_exchange_date:[String] = []
    var myCon_Vali_order_date:[String] = []
    var myCon_Vali_exchange_status:[String] = []
    var myCon_Vali_cancel_period:[String] = []
    var myCon_Vali_cancelable:[String] = []
    var myCon_Vali_Detail_Data:[String] = []

}

// 스마트콘 - 상품정보
class Data_SmartCon_Goods {
    static let shared: Data_SmartCon_Goods = Data_SmartCon_Goods()
    var smartCon_Goods_disc_price:[String] = []
    var smartCon_Goods_disc_rate:[String] = []
    var smartCon_Goods_goods_id:[String] = []
    var smartCon_Goods_goods_name:[String] = []
    var smartCon_Goods_img_url:[String] = []
    var smartCon_Goods_msg:[String] = []
    var smartCon_Goods_price:[String] = []
    var smartCon_Goods_cancelable:[String] = []
    
}



