//
//  RecommenderIdTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol RecommenderIdTableCellProtocol {
    func recommenderIdCheck(recommenderIdCheck:RecommenderIdTableCell)
}

// 회원가입 -> 추천인 아이디 선택 셀
class RecommenderIdTableCell:UITableViewCell,UITextFieldDelegate {

    
    
    @IBOutlet weak var inputRecommenderIdTF: UITextField!
    @IBOutlet weak var btn_RecommenderCheck: UIButton!
    
    
    let serviceUrl = UrlData()
    var recommenderAuthEndAfterChange:String = ""
    
    var delegate:RecommenderIdTableCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        cellSetting()
        inputRecommenderIdTF.delegate = self
        inputRecommenderIdTF.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func strChanged(_ sender: Any) {
        let str = inputRecommenderIdTF?.text
        if recommenderAuthEndAfterChange == "success" {
            let push_id = Data_SignUp.shared.signUp_User_PushId
            if push_id != str {
                Data_SignUp.shared.signUp_User_PushId_Result = "fail"
                Data_SignUp.shared.signUp_User_PushId = ""
                recommenderAuthEndAfterChange = "fail"
            }
        }
        Data_SignUp.shared.signUp_User_PushId = str!
    }
    
    @IBAction func recommenderIdCheckBtn(_ sender: UIButton) {
        guard let push_id = inputRecommenderIdTF.text else { return }
        do {
            
            let url = serviceUrl.realServiceUrl + "/onepay/rest/recommenderCheck"
            let param: Parameters = [
                "push_id": push_id,
                ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                print("JSON=\(response.result.value!)")
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1" {
                        print("추천인 있음 !!")
                        Data_SignUp.shared.signUp_User_PushId_Result = "success"
                        Data_SignUp.shared.signUp_User_PushId = self.inputRecommenderIdTF.text!
                        self.recommenderAuthEndAfterChange = "success"
                        self.delegate?.recommenderIdCheck(recommenderIdCheck: self)
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        print("추천인 없음 !!")
                        Data_SignUp.shared.signUp_User_PushId_Result = "fail"
                        Data_SignUp.shared.signUp_User_PushId = ""
                        self.delegate?.recommenderIdCheck(recommenderIdCheck: self)
                    } else {
                        print("등록실패")
                        Data_SignUp.shared.signUp_User_PushId_Result = "fail"
                        Data_SignUp.shared.signUp_User_PushId = ""
                        self.recommenderAuthEndAfterChange = "fail"
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
        inputRecommenderIdTF.layer.cornerRadius = 10
        inputRecommenderIdTF.borderStyle = .none
        inputRecommenderIdTF.keyboardType = .alphabet
        inputRecommenderIdTF.autocorrectionType = UITextAutocorrectionType.no
        inputRecommenderIdTF.spellCheckingType = UITextSpellCheckingType.no
        inputRecommenderIdTF.clearButtonMode = .whileEditing
    }
    
    // 텍스트 필듸의 내용이 변경될 때 호출 + 입력 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 11
    }
    // 리턴키 눌렀을때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputRecommenderIdTF.resignFirstResponder()
        return true
    }
    
    @IBAction func editBegin(_ sender: Any) {

        Data_Default.shared.IndexPathNum = "up"
    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
}
