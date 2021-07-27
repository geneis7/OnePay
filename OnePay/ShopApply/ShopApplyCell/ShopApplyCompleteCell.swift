//
//  ShopApplyCompleteCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ShopApplyCompleteCellProtocol {
    func shopApplyCompleteCell(shopApplyCompleteCell:ShopApplyCompleteCell)
}

class ShopApplyCompleteCell: UITableViewCell {
    
    var delegate:ShopApplyCompleteCellProtocol?
    let serviceUrl = UrlData()
    var resultCode:String = ""
    @IBOutlet weak var btn_ShopApply: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_ShopApply.layer.cornerRadius = 10
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func shopApplyCompleteBtn(_ sender: Any) {

        let member_srl = Data_MemberInfo.shared.member_srl
        let name = Data_ShopApply.shared.shopApply_Name
        let comp_name = Data_ShopApply.shared.shopApply_Company_Name
        let comp_no = Data_ShopApply.shared.shopApply_BusinessNum
        let bank = Data_ShopApply.shared.shopApply_Select_BankCode
        let voucher = Data_ShopApply.shared.shopApply_AccountHolder
        let account_number = Data_ShopApply.shared.shopApply_AccountNumber
        let cell_num = Data_ShopApply.shared.shopApply_PhoneNumber
        let address = Data_ShopApply.shared.shopApply_Address
        let comp_intro = Data_ShopApply.shared.shopApply_CompanyInfo
        let online_shop = Data_ShopApply.shared.shopApply_Division
        let web_url = Data_ShopApply.shared.shopApply_HomePage
   
        if name == "" {
            resultCode = "1"
        } else if comp_name == ""  {
            resultCode = "2"
        } else if comp_no == "" {
            resultCode = "3"
        } else if bank == "" {
            resultCode = "4"
        } else if voucher == "" {
            resultCode = "5"
        } else if account_number == "" {
            resultCode = "6"
        } else if cell_num == "" || cell_num.count < 10 || cell_num.count > 11 {
            resultCode = "7"
        } else if address == "" || address.count > 100 {
            resultCode = "8"
        } else if comp_intro == "" || comp_intro.count > 1000 {
            resultCode = "9"
        } else if online_shop == "" {
            resultCode = "10"
        } else {
            resultCode = "success"
        }
        
        
        Data_ShopApply.shared.shopApply_Complete_result = resultCode
        if resultCode == "success" {
            
            do {
                
                let url = serviceUrl.realServiceUrl + "/onepay/rest/mallApply"
                let param: Parameters = [
                    "member_srl": member_srl,
                    "name": name,
                    "comp_name": comp_name,
                    "comp_no": comp_no,
                    "bank": bank,
                    "voucher": voucher,
                    "account_number": account_number,
                    "cell_num": cell_num,
                    "address": address,
                    "comp_intro": comp_intro,
                    "online_shop": online_shop,
                    "web_url": web_url
                ]
                
                print("member_srl = " + "\(member_srl)")
                print("name = " + "\(name)")
                print("comp_name = " + "\(comp_name)")
                print("comp_no = " + "\(comp_no)")
                print("bank = " + "\(bank)")
                print("voucher = " + "\(voucher)")
                print("account_number = " + "\(account_number)")
                print("cell_num = " + "\(cell_num)")
                print("address = " + "\(address)")
                print("comp_intro = " + "\(comp_intro)")
                print("online_shop = " + "\(online_shop)")
                print("web_url = " + "\(web_url)")
                
                let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
                alamo.responseJSON() { response in
                    print("JSON=\(response.result.value!)")
                    if let jsonObject = response.result.value as? [String: Any] {
                        if String(describing: (jsonObject["resultCode"]!)) == "1" {
                            print("//---------->   원페이 가맹점 신청 성공  <----------//")
                            Data_ShopApply.shared.shopApply_Complete_result = "success"
                            
                        } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                            print("//---------->   원페이 가맹점 신청 실패  <----------//")
                            Data_ShopApply.shared.shopApply_Complete_result = "fail"
                            
                        } else {
                            print("원페이 가맹점 신청 실패")
                            Data_ShopApply.shared.shopApply_Complete_result = "fail"
                        }
                        self.delegate?.shopApplyCompleteCell(shopApplyCompleteCell: self)
                        print("resultCode = \(jsonObject["resultCode"]!)")
                        print("resultMessage = \(jsonObject["resultMessage"]!)")
                    }
                }
            }
        } else {
            self.delegate?.shopApplyCompleteCell(shopApplyCompleteCell: self)
        }
    }
}
