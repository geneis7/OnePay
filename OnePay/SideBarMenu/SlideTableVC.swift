//
//  SlideTableViewController.swift
//  ImplineApp
//
//  Created by 유하늘 on 2017. 9. 19..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SlideTableVC: UIViewController , UITableViewDelegate , UITableViewDataSource,SlideCellMainProtocol {
    
    let serviceUrl = UrlData()
    let ud = UserDefaults.standard
    var checked = Set<IndexPath>()
    
    
    // 가맹점 리스트 이미지 주소 불러오기
    var shopListData:JSON = JSON.init(rawValue: [])!
    var shopListArray:[String] = []
    var shopLinkArray:[String] = []
    
    // 스마트콘 - 이벤트 아이디
    var smartConData:JSON = JSON.init(rawValue: [])!
    
    // 스마트콘 - 카테고리 영역
    var smartConCateListData:JSON = JSON.init(rawValue: [])!
    var smartCon_cate_code:[String] = []
    var smartCon_cate_name:[String] = []
    var smartCon_icon_url:[String] = []
    var cateCode_ArrayCnt:Int?
    var cateCode_LoopCnt:Int = 1
    
    // 스마트콘 - 브랜드 영역
    var smartConBrandListData:JSON = JSON.init(rawValue: [])!
    var smartCon_brand_name:[String] = []
    var smartCon_brand_code:[String] = []
    var smartCon_brand_img:[String] = []
    var smartCon_brand_cate_code:[String] = []
    var smartCon_brand_cate_name:[String] = []
    var smartCon_brand_Array_Cnt = [String:String]()
    var smartCon_brand_Array_Total_Cnt:Int = 1
    var smartCon_brand_Array_Total_Array:[String] = []
    
    
    // 스마트콘 - 나의쿠폰 영역
    var myConListData:JSON = JSON.init(rawValue: [])!
    var myCon_tr_id:[String] = []
    var myCon_member_srl:[String] = []
    var myCon_event_id:[String] = []
    var myCon_goods_id:[String] = []
    var myCon_disc_price:[String] = []
    var myCon_disc_rate:[String] = []
    var myCon_price:[String] = []
    var myCon_order_cnt:[String] = []
    var myCon_img_url:[String] = []
    var myCon_exchange_status:[String] = []
    var myCon_goods_name:[String] = []
    var myCon_brand_name:[String] = []
    var myCon_total_cnt:String = ""
    
    // 스마트콘 - 실시간 교환상태 영역
    var myConList_ValiData:JSON = JSON.init(rawValue: [])!
    var myCon_Vali_claim_type:[String] = []
    var myCon_Vali_valid_start:[String] = []
    var myCon_Vali_valid_end:[String] = []
    var myCon_Vali_tr_id:[String] = []
    var myCon_Vali_exchange_date:[String] = []
    var myCon_Vali_order_date:[String] = []
    var myCon_Vali_exchange_status:[String] = []
    var myCon_Vali_cancel_period:[String] = []
    var myCon_Vali_cancelable:[String] = []
    var myCon_Vali_loop_cnt:Int = 0
    var myCon_Vali_loop_cnt2:Int = 0
    
    var brandTotalCnt = 0
    var cnt = 0
    
    func slideCellMain(slideCellMain: SlideCellMain) {
        
        
        
        if Data_Default.shared.slideCellMainGotoValue == "1" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "MemberInfoStoryID")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        } else if Data_Default.shared.slideCellMainGotoValue == "2" {
            let alert = UIAlertController(title:"원페이", message:"이용료를 납부 하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .destructive)
            // 컨트롤 뷰 컨트롤러를 알림창에 등록한다.
            let okAction = UIAlertAction(title: "확인", style: .default){
                UIAlertAction in
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FeesPayStoryID")
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
            alert.addAction(cancel)
            alert.addAction(okAction)
            self.present(alert, animated: false)
        }
    }
    
    @IBOutlet weak var slideTableView: UITableView!
    
    let cellList:[String] = ["MemberInfoStoryID",
                             "SWReveal_CardInfo",
                             "SWReveal_MyAccount",
                             "SWReveal_ChargeHistory",
                             "SWReveal_TransHistory",
                             "SWReveal_ServiceCenter",
//                             "SWReveal_SmartCon",
//                             "FeesPayStoryID",
                             "ShopListStoryID",
                             "SWReveal_ShopApply",
                             "LoginStoryID"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cateCode_LoopCnt = 1
        myCon_Vali_loop_cnt = 0
        eventIdDataLoad()
        shopListDataLoad()
        

        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        
        // 슬라이드 메뉴 메인 - 내정보
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellMain") as! SlideCellMain
            
            cell.delegate = self
            return cell
        }
            
            // 카드 정보 셀
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellCardInfo") as! SlideCellCardInfo
            
            return cell
        }
            // 나의 계좌 정보 셀
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellMyAccount") as! SlideCellMyAccount
            
            return cell
        }
            // 충전내역 조회 셀
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellChargeHistory") as! SlideCellChargeHistory
            
            return cell
        }
            // 거래내역 조회 셀
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellTransHistory") as! SlideCellTransHistory
            
            return cell
        }
            // 서비스센터 셀
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellServiceCenter") as! SlideCellServiceCenter
            
            return cell
        }
            
//            // 스마트콘 셀
//        else if indexPath.row == 6 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellSmartCon") as! SlideCellSmartCon
//
//            return cell
//        }
            
//            // 이용료 납부 셀
//        else if indexPath.row == 7 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellFeesPay") as! SlideCellFeesPay
//
//
//            return cell
//        }
            
            // 가맹점 리스트 셀
        else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellShopList") as! SlideCellShopList
            
            return cell
        }
            
            // 가맹점 신청 셀
        else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellShopApply") as! SlideCellShopApply
            
            return cell
        }
            
//            // 로그아웃 셀
//        else if indexPath.row == 8 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellLogOut") as! SlideCellLogOut
//            
//            return cell
//        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCellLogOut") as! SlideCellLogOut

            return cell
        }
    }
    
    // 가입정보 임시저장 값 삭제
    func resetDefaults() {
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
    
    // FcmKey 해제
  
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let myAcc = Data_MemberAsset.shared.acc_no
        var ControllerName = cellList[indexPath.row]
        
        if ControllerName == "SWReveal_MyAccount" {
            if myAcc != "" {
                ControllerName = "SWReveal_MyAccountHave"
            } else {
                ControllerName = "SWReveal_MyAccount"
            }
        }
        
        if ControllerName == "SWReveal_SmartCon" {

            self.myCouponListLoad()
            return
        }
        
        if ControllerName != "LoginStoryID" {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: ControllerName)
            
            self.navigationController?.pushViewController(nextVC!, animated: true)
            
        } else {
            let title = "OnePay \n\n"
            let message = "나중에 다시 로그인 하시면 회원님의 가상계좌와 포인트,별은 그대로 유지 됩니다." + "\n"
                + "단, 송금 히스토리와 기타 설정들은 로그아웃시 보안상 초기화됩니다." + "\n"
                + "로그아웃 하시겠습니까?" + "\n\n"
            
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "취소", style: .destructive)
            
            let action = UIAlertAction(title: "확인", style: .default) {
                UIAlertAction in
                self.resetDefaults()
                ServerTrans_UnRegistFcmKey.shared.registFcmKeySend()
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {

                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginStoryID")
                    self.navigationController?.pushViewController(nextVC!, animated: true)
                }
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            
            let messageText = NSMutableAttributedString(
                string: "나중에 다시 로그인 하시면 회원님의 가상계좌와 포인트,별은 그대로 유지 됩니다." + "\n\n"
                    + "단, 송금 히스토리와 기타 설정들은 로그아웃시 보안상 초기화됩니다." + "\n\n"
                    + "로그아웃 하시겠습니까?",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ]
            )
            
            alert.setValue(messageText, forKey: "attributedMessage")
            
            alert.addAction(cancel)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 가맹점 리스트 데이터 불러오기
    func shopListDataLoad() {
        
        let url = serviceUrl.realServiceUrl + "/onepay/rest/shopList"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.shopListData = JSON(value)
                
                Data_ShopList.shared.shopList_Image =  self.shopListData["shopArr"].arrayValue.map({$0["banner_img"].stringValue})
                Data_ShopList.shared.shopList_Url =  self.shopListData["shopArr"].arrayValue.map({$0["link_url"].stringValue})
    
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 이벤트ID 데이터 불러오기
    func eventIdDataLoad() {
        
        let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/getEventCode"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.smartConData = JSON(value)
                
                Data_SmartCon.shared.smartCon_EventId = String(describing: self.smartConData["event_id"])
                
                self.categorieListDataLoad()
            case .failure(let error):
                print(error)
            }
        }
    }

    
    // 카테고리 리스트 데이터 불러오기
    func categorieListDataLoad() {
        let event_id = Data_SmartCon.shared.smartCon_EventId
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/cateList"
            let param: Parameters = [
                "event_id" : event_id
            ]
        
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                    
                case .success(let value):
                    self.smartConCateListData = JSON(value)

                    Data_SmartCon.shared.smartCon_cate_name = self.smartConCateListData["cateArr"].arrayValue.map({$0["cate_name"].stringValue})
                    Data_SmartCon.shared.smartCon_cate_code = self.smartConCateListData["cateArr"].arrayValue.map({$0["cate_code"].stringValue})
                    Data_SmartCon.shared.smartCon_icon_url = self.smartConCateListData["cateArr"].arrayValue.map({$0["icon_url"].stringValue})
                    
                     print("smartCon_cate_code = " + "\(Data_SmartCon.shared.smartCon_cate_name)")
                     print("smartCon_cate_name = " + "\(Data_SmartCon.shared.smartCon_cate_code)")
                     print("smartCon_icon_url = " + "\(Data_SmartCon.shared.smartCon_icon_url)")

                    self.cateCode_ArrayCnt = Data_SmartCon.shared.smartCon_cate_code.count
                    
                    
                    for _ in self.cateCode_LoopCnt...self.cateCode_ArrayCnt! {
                        let when = DispatchTime.now() + 0.1
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.brandListDataLoad()
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // 브랜드 리스트 데이터 불러오기
    func brandListDataLoad() {
        
        let event_id = Data_SmartCon.shared.smartCon_EventId
        var cate_code = "00" + String(self.cateCode_LoopCnt)
        if self.cateCode_LoopCnt >= 10 {
            cate_code = "0" + String(self.cateCode_LoopCnt)
        }
        print("****************** 브랜드 데이터 로드 ******************")
        cateCode_LoopCnt = cateCode_LoopCnt + 1
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/brandList"
            let param: Parameters = [
                "event_id" : event_id,
                "cate_code" : cate_code
            ]
            
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                    
                case .success(let value):
                    
                    self.smartConBrandListData = JSON(value)
                    self.smartCon_brand_name =  self.smartConBrandListData["brandArr"].arrayValue.map({$0["brand_name"].stringValue})
                    self.smartCon_brand_code =  self.smartConBrandListData["brandArr"].arrayValue.map({$0["brand_code"].stringValue})
                    self.smartCon_brand_img =  self.smartConBrandListData["brandArr"].arrayValue.map({$0["brand_img"].stringValue})
                    self.smartCon_brand_cate_code =  self.smartConBrandListData["brandArr"].arrayValue.map({$0["cate_code"].stringValue})
                    self.smartCon_brand_cate_name =  self.smartConBrandListData["brandArr"].arrayValue.map({$0["cate_name"].stringValue})
                    
                    let cate_code = Int(self.smartCon_brand_cate_code[0])!
                    
                    /*
                     print("////////////////////////////// 브랜드 정보 불러오기 //////////////////////////////")
                     print("////////////////self.cateCode_LoopCnt = " + "\(cate_code)")
                     print("smartCon_brand_name" + "\(cate_code)" + " = " + "\(self.smartCon_brand_name)")
                     print("smartCon_brand_code" + "\(cate_code)" + " = " + "\(self.smartCon_brand_code)")
                     print("smartCon_brand_img" + "\(cate_code)" + " = " + "\(self.smartCon_brand_img)")
                     print("smartCon_brand_cate_code" + "\(cate_code)" + " = " + "\(self.smartCon_brand_cate_code)")
                     print("////////////////////////////////////////////////////////////////////////////////////")
                     print("")
                     */
                    self.smartCon_brand_Array_Cnt["\(cate_code)"] = String(self.smartCon_brand_name.count)
                    
                    if self.smartCon_brand_Array_Cnt.count == self.cateCode_ArrayCnt {
                        for _ in 1...self.cateCode_ArrayCnt! {
                            self.smartCon_brand_Array_Total_Array.append(self.smartCon_brand_Array_Cnt["\(self.smartCon_brand_Array_Total_Cnt)"]!)
                            self.smartCon_brand_Array_Total_Cnt += 1
                        }
                    }
                    Data_SmartCon.shared.smartCon_brand_Total_Array = self.smartCon_brand_Array_Total_Array
                    Data_SmartCon.shared.smartCon_brand_name_array["SmartCon_brand_name_" + "\(cate_code)"] = self.smartCon_brand_name
                    Data_SmartCon.shared.smartCon_brand_code_array["SmartCon_brand_code_" + "\(cate_code)"] = self.smartCon_brand_code
                    Data_SmartCon.shared.smartCon_brand_cate_code_array["SmartCon_brand_cate_code" + "\(cate_code)"] = self.smartCon_brand_cate_code
                    Data_SmartCon.shared.smartCon_brand_img_array["SmartCon_brand_img_" + "\(cate_code)"] = self.smartCon_brand_img
                    print(Data_SmartCon.shared.smartCon_brand_name_array["SmartCon_brand_name_" + "\(cate_code)"]!)
                    print(Data_SmartCon.shared.smartCon_brand_code_array["SmartCon_brand_code_" + "\(cate_code)"]!)
                    print(Data_SmartCon.shared.smartCon_brand_cate_code_array["SmartCon_brand_cate_code" + "\(cate_code)"]!)
                    print(Data_SmartCon.shared.smartCon_brand_img_array["SmartCon_brand_img_" + "\(cate_code)"]!)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // 보유쿠폰 데이터 불러오기
    func myCouponListLoad() {
        let member_srl = Data_MemberInfo.shared.member_srl
        let start_num = "0"
        let list_num = "5"
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/myCoupon"
            let param: Parameters = [
                "member_srl" : member_srl,
                "start_num" : start_num,
                "list_num" : list_num
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                    
                case .success(let value):
                    self.myConListData = JSON(value)
                    print(self.myConListData)
                    Data_SmartCon_MyCon.shared.myCon_tr_id_array =  self.myConListData["couponArr"].arrayValue.map({$0["tr_id"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_member_srl_array =  self.myConListData["couponArr"].arrayValue.map({$0["member_srl"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_event_id_array =  self.myConListData["couponArr"].arrayValue.map({$0["event_id"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_goods_id_array =  self.myConListData["couponArr"].arrayValue.map({$0["goods_id"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_disc_price_array =  self.myConListData["couponArr"].arrayValue.map({$0["disc_price"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_disc_rate_array =  self.myConListData["couponArr"].arrayValue.map({$0["disc_rate"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_price_array =  self.myConListData["couponArr"].arrayValue.map({$0["price"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_order_cnt_array =  self.myConListData["couponArr"].arrayValue.map({$0["order_cnt"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_img_url_array =  self.myConListData["couponArr"].arrayValue.map({$0["img_url"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_exchange_status_array =  self.myConListData["couponArr"].arrayValue.map({$0["exchange_status"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_goods_name_array =  self.myConListData["couponArr"].arrayValue.map({$0["goods_name"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_brand_name_array =  self.myConListData["couponArr"].arrayValue.map({$0["brand_name"].stringValue})
                    Data_SmartCon_MyCon.shared.myCon_total_cnt = self.myConListData["totalCnt"].string!
                    
                  
                     print("myCon_tr_id = " + "\(Data_SmartCon_MyCon.shared.myCon_tr_id_array)")
                     print("myCon_member_srl = " + "\(Data_SmartCon_MyCon.shared.myCon_member_srl_array)")
                     print("myCon_event_id = " + "\(Data_SmartCon_MyCon.shared.myCon_event_id_array)")
                     print("myCon_goods_id = " + "\(Data_SmartCon_MyCon.shared.myCon_goods_id_array)")
                     print("myCon_goods_id = " + "\(Data_SmartCon_MyCon.shared.myCon_disc_price_array)")
                     print("myCon_disc_price = " + "\(Data_SmartCon_MyCon.shared.myCon_disc_rate_array)")
                     print("myCon_disc_rate = " + "\(Data_SmartCon_MyCon.shared.myCon_price_array)")
                     print("myCon_price = " + "\(Data_SmartCon_MyCon.shared.myCon_order_cnt_array)")
                     print("myCon_order_cnt = " + "\(self.myCon_order_cnt)")
                     print("myCon_img_url = " + "\(Data_SmartCon_MyCon.shared.myCon_img_url_array)")
                     print("myCon_exchange_status = " + "\(Data_SmartCon_MyCon.shared.myCon_exchange_status_array)")
                     print("myCon_goods_name = " + "\(Data_SmartCon_MyCon.shared.myCon_goods_name_array)")
                     print("myCon_brand_name = " + "\(Data_SmartCon_MyCon.shared.myCon_brand_name_array)")
                    
                    
                    let when = DispatchTime.now() + 0.1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        if Data_SmartCon_MyCon.shared.myCon_tr_id_array.count != 0 {
                            self.myCouponStatusLoad()
                        } else {
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_SmartCon")
                            
                            self.navigationController?.pushViewController(nextVC!, animated: true)
                        }
                    }
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // 스마트콘 실시간 교환상태 조회
    func myCouponStatusLoad() {
        let tr_id  = Data_SmartCon_MyCon.shared.myCon_tr_id_array[cnt]
        let event_id = Data_SmartCon.shared.smartCon_EventId
        
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/validateCoupon"
            let param: Parameters = [
                "tr_id" : tr_id,
                "event_id" : event_id
            ]
        
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                
                switch response.result {
                    
                case .success(let value):
                    
                    self.myConList_ValiData = JSON(value)
                    
                    let vali_1 = self.myConList_ValiData["claim_type"].string!
                    let vali_2 = self.myConList_ValiData["valid_start"].string!
                    let vali_3 = self.myConList_ValiData["valid_end"].string!
                    let vali_4 = self.myConList_ValiData["tr_id"].string!
                    let vali_5 = self.myConList_ValiData["exchange_date"].string!
                    let vali_6 = self.myConList_ValiData["order_date"].string!
                    let vali_7 = self.myConList_ValiData["exchange_status"].string!
                    let vali_8 = self.myConList_ValiData["cancel_period"].string!
                    let vali_9 = self.myConList_ValiData["cancelable"].string!
                    
                    self.myCon_Vali_claim_type.append(vali_1)
                    self.myCon_Vali_valid_start.append(vali_2)
                    self.myCon_Vali_valid_end.append(vali_3)
                    self.myCon_Vali_tr_id.append(vali_4)
                    self.myCon_Vali_exchange_date.append(vali_5)
                    self.myCon_Vali_order_date.append(vali_6)
                    self.myCon_Vali_exchange_status.append(vali_7)
                    self.myCon_Vali_cancel_period.append(vali_8)
                    self.myCon_Vali_cancelable.append(vali_9)
                    
                    self.cnt += 1
                    
                    if self.cnt < Data_SmartCon_MyCon.shared.myCon_brand_name_array.count  {
                        self.myCouponStatusLoad()
                        
                    } else {
                        
                        print(self.myCon_Vali_claim_type)
                        print(self.myCon_Vali_valid_start)
                        print(self.myCon_Vali_valid_end)
                        print(self.myCon_Vali_tr_id)
                        print(self.myCon_Vali_exchange_date)
                        print(self.myCon_Vali_order_date)
                        print(self.myCon_Vali_exchange_status)
                        print(self.myCon_Vali_cancel_period)
                        print(self.myCon_Vali_cancelable)
                        
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_claim_type = self.myCon_Vali_claim_type
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_valid_start = self.myCon_Vali_valid_start
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_valid_end = self.myCon_Vali_valid_end
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_tr_id = self.myCon_Vali_tr_id
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_exchange_date = self.myCon_Vali_exchange_date
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_order_date = self.myCon_Vali_order_date
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_exchange_status = self.myCon_Vali_exchange_status
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_cancel_period = self.myCon_Vali_cancel_period
                        Data_SmartCon_MyCon_Vali.shared.myCon_Vali_cancelable = self.myCon_Vali_cancelable
                        
                        
                        self.myCon_Vali_claim_type.removeAll()
                        self.myCon_Vali_valid_start.removeAll()
                        self.myCon_Vali_valid_end.removeAll()
                        self.myCon_Vali_tr_id.removeAll()
                        self.myCon_Vali_exchange_date.removeAll()
                        self.myCon_Vali_order_date.removeAll()
                        self.myCon_Vali_exchange_status.removeAll()
                        self.myCon_Vali_cancel_period.removeAll()
                        self.myCon_Vali_cancelable.removeAll()
                        self.myCon_tr_id.removeAll()
                        self.myCon_member_srl.removeAll()
                        self.myCon_event_id.removeAll()
                        self.myCon_goods_id.removeAll()
                        self.myCon_disc_price.removeAll()
                        self.myCon_disc_rate.removeAll()
                        self.myCon_price.removeAll()
                        self.myCon_order_cnt.removeAll()
                        self.myCon_img_url.removeAll()
                        self.myCon_exchange_status.removeAll()
                        self.myCon_goods_name.removeAll()
                        self.myCon_brand_name.removeAll()
                        
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_SmartCon")
                        
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
