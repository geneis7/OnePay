//
//  EditRecommenderIdTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol RecommenderIdCheckProtocol {
    func recommenderIdCheck(recommenderIdCheck: EditRecommenderIdTableCell)
}


class EditRecommenderIdTableCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var editRecommenderIdTableCellBtn: UIButton!
    @IBOutlet weak var editRecommenderIdTableCellTF: UITextField!
    let serviceUrl = UrlData()
    var push_id:String = ""
    var push_change:String = ""
    var delegate:RecommenderIdCheckProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        push_id = Data_MemberInfo.shared.push_id
        push_change = Data_MemberInfo.shared.push_change
        cellSetting()
        editRecommenderIdTableCellTF.delegate = self
        editRecommenderIdTableCellTF.text = push_id
        if push_change == "Y" {
            editRecommenderIdTableCellTF.isEnabled = true
        } else if push_change == "N" {
            self.editRecommenderIdTableCellTF.isEnabled = false
            self.editRecommenderIdTableCellBtn.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func recommenderIdCheckBtn(_ sender: Any) {
        
        guard let edit_push_id = editRecommenderIdTableCellTF.text else { return }
        do {
            
            let url = serviceUrl.realServiceUrl + "/onepay/rest/recommenderCheck"
            let param: Parameters = [
                "push_id": edit_push_id,
                ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        print("추천인 있음 !!")
                        
                        Data_MemberInfo_Edit.shared.edit_Push_Id = edit_push_id
                        Data_MemberInfo_Edit.shared.edit_Push_Id_Result = "success"
                        self.delegate?.recommenderIdCheck(recommenderIdCheck: self)
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        print("추천인 없음 !!")
                        Data_MemberInfo_Edit.shared.edit_Push_Id_Result = "fail"
                        self.delegate?.recommenderIdCheck(recommenderIdCheck: self)
                    } else {
                        print("등록실패")
                        Data_MemberInfo_Edit.shared.edit_Push_Id_Result = "fail"
                        self.delegate?.recommenderIdCheck(recommenderIdCheck: self)
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
        
    // 기본 셀 셋팅
    func cellSetting(){
        editRecommenderIdTableCellTF.borderStyle = .none
        editRecommenderIdTableCellTF.keyboardType = .asciiCapable
        editRecommenderIdTableCellTF.clearButtonMode = .whileEditing
        editRecommenderIdTableCellTF.autocorrectionType = UITextAutocorrectionType.no
        editRecommenderIdTableCellTF.spellCheckingType = UITextSpellCheckingType.no
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editRecommenderIdTableCellTF.resignFirstResponder()
        return true
    }
    
    
    @IBAction func editBegin(_ sender: Any) {
        Data_MemberInfo_Edit.shared.memberInfoIndexPath = "up"
    }
    
    
    @IBAction func editEnd(_ sender: Any) {
        Data_MemberInfo_Edit.shared.memberInfoIndexPath = ""
    }
}
