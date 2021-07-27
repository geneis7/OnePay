//
//  ShopBankNameCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol ShopBankNameCellProtocol{
    func shopBankNameCellProtocol(shopBankNameCellProtocol : ShopBankNameCell)
}

class ShopBankNameCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var shopBankNameCellTF: UITextField!
    @IBOutlet weak var btn_BankName: UIButton!
    
    let serviceUrl = UrlData()
    
    var bankListData:JSON = JSON.init(rawValue: [])!
    var bankList:[String:String] = [:]
    var bankName:[String] = []
    var bankCode:[String] = []
    
    var delegate:ShopBankNameCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_BankName.layer.cornerRadius = 10
        bankListDataLoad()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let bank_name = Data_ShopApply.shared.shopApply_Select_BankName
        if bank_name != "" {
            shopBankNameCellTF.text = String(describing: bank_name)
        } else {
            shopBankNameCellTF.attributedPlaceholder = NSAttributedString(string: "은행 선택",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shopBankNameCellTF.resignFirstResponder()
        return true
    }
    
    // 은행 선택 버튼
    @IBAction func realBankSelectBtn(_ sender: Any) {
        self.delegate?.shopBankNameCellProtocol(shopBankNameCellProtocol: self)
    }
    
    func defaultSetting(){
        shopBankNameCellTF.isEnabled = false
        shopBankNameCellTF.delegate = self
        shopBankNameCellTF.attributedPlaceholder = NSAttributedString(string: "은행 선택",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
    }
    
    func bankListDataLoad(){
        let url = serviceUrl.realServiceUrl + "/onepay/rest/bankList"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.bankListData = JSON(value)
                print("//---------->    은행 get 응답  <----------//")
                
                Data_BankInfo.shared.bankListName =  self.bankListData["bankList"].arrayValue.map({$0["bank_name"].stringValue})
                
                Data_BankInfo.shared.bankListCode =  self.bankListData["bankList"].arrayValue.map({$0["bank_code"].stringValue})
                
                var nameListCnt = 0
                var codeListCnt = 0
                while nameListCnt != Data_BankInfo.shared.bankListName.count {
                    Data_BankInfo.shared.bankSorted_Name[Data_BankInfo.shared.bankListName[codeListCnt]] = Data_BankInfo.shared.bankListCode[nameListCnt]
                    nameListCnt = nameListCnt + 1
                    codeListCnt = codeListCnt + 1
                }
                
                self.defaultSetting()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
