//
//  ShopApplyRealBankListTableVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 3. 13..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopApplyRealBankListTableVC: UITableViewController {
  
    var delegate:ShopApplyVC?
    var bankNameList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bankNameList =  Data_BankInfo.shared.bankListName
        
        self.preferredContentSize.height = 220
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return bankNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = bankNameList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectBankName = bankNameList[indexPath.row]
        
        let selectBankCode = Data_BankInfo.shared.bankSorted_Name[selectBankName]

        Data_ShopApply.shared.shopApply_Select_BankName = selectBankName
        Data_ShopApply.shared.shopApply_Select_BankCode = selectBankCode!
    
        
        print("//---------->    은행선택 결과  <----------//")
        print("선택된 은행은 \(bankNameList[indexPath.row])입니다.")
        print("선택된 은행코드는 \(String(describing: selectBankCode))입니다.")
    }
}

