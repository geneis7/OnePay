//
//  BranchNameTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Toaster

protocol BranchNameProtocol{
    func branchName(branchName : BranchNameTableCell)
}



// 회원가입 -> 지점명 선택 셀
class BranchNameTableCell:UITableViewCell,BranchNameProtocol,UITextFieldDelegate{

    
    
    @IBOutlet weak var btn_BranchSelect: UIButton!
    @IBOutlet weak var BranchNameTableCellTF: UITextField!
    
    let serviceUrl = UrlData()
    
    var branchData:JSON = JSON.init(rawValue: [])!
    var branchList:[String:String] = [:]
    var branchName:[String] = []
    var branchCode:[String] = []
    
    
    var branchDelegate:BranchNameProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        BranchNameTableCellTF.attributedPlaceholder = NSAttributedString(string: "지점선택",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        btn_BranchSelect.layer.cornerRadius = 10
        BranchNameTableCellTF.delegate = self
        BranchNameTableCellTF.isEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let branchName = Data_SignUp.shared.signUp_Select_Branch_Name
        if branchName != "" {
            BranchNameTableCellTF.text = branchName
        } else {

            BranchNameTableCellTF.attributedPlaceholder = NSAttributedString(string: "지점명",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    func branchName(branchName: BranchNameTableCell) {
        let branchName = Data_SignUp.shared.signUp_Select_Branch_Name
        
        self.BranchNameTableCellTF?.text = branchName
    }
    
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
    
    
    @IBAction func branchNameSelectBtn(_ sender: Any) {

        let url = serviceUrl.realServiceUrl + "/onepay/rest/branchList"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.branchData = JSON(value)
                Data_SignUp.shared.signUp_branch_Name =  self.branchData["branchList"].arrayValue.map({$0["name"].stringValue})
                Data_SignUp.shared.signUp_branch_Code =  self.branchData["branchList"].arrayValue.map({$0["code"].stringValue})

                var nameListCnt = 0
                var codeListCnt = 0
                while nameListCnt != Data_SignUp.shared.signUp_branch_Name.count {
                    
                    Data_SignUp.shared.signUp_branch_List["\(Data_SignUp.shared.signUp_branch_Name[codeListCnt])"] =  Data_SignUp.shared.signUp_branch_Code[nameListCnt]
                    
                    
                    nameListCnt = nameListCnt + 1
                    codeListCnt = codeListCnt + 1
                }
                
                self.branchDelegate?.branchName(branchName: self)
            case .failure(let error):
                print(error)
            }
        }
    }
}
