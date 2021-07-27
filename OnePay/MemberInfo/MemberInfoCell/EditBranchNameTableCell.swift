//
//  EditBranchNameTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class EditBranchNameTableCell: UITableViewCell {

    @IBOutlet weak var editBranchNameTableCellLabel: UILabel!
    
    let serviceUrl = UrlData()
    
    var branchData:JSON = JSON.init(rawValue: [])!
    var branchList:[String:String] = [:]
    var branchName:[String] = []
    var branchCode:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        branchDataLoad()
        let branchCode = Data_MemberInfo.shared.branch
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("딜레이 실행")
            self.editBranchNameTableCellLabel.text = Data_MemberInfo_Edit.shared.branch_List[branchCode]
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func branchDataLoad(){
        let url = serviceUrl.realServiceUrl + "/onepay/rest/branchList"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.branchData = JSON(value)

                Data_MemberInfo_Edit.shared.branch_Name = self.branchData["branchList"].arrayValue.map({$0["name"].stringValue})
                Data_MemberInfo_Edit.shared.branch_Code = self.branchData["branchList"].arrayValue.map({$0["code"].stringValue})
                
                var nameListCnt = 0
                var codeListCnt = 0
                while nameListCnt != Data_MemberInfo_Edit.shared.branch_Name.count {
                    
                    Data_MemberInfo_Edit.shared.branch_List["\(Data_MemberInfo_Edit.shared.branch_Code[codeListCnt])"] =  Data_MemberInfo_Edit.shared.branch_Name[nameListCnt]
                    
                    nameListCnt = nameListCnt + 1
                    codeListCnt = codeListCnt + 1
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
