//
//  IdTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Toaster

protocol IdTableCellProtocol {
    func signUpIdCheck(signUpIdCheck:IdTableCell)
}


// 회원가입 -> 본인인증 id 중복확인 셀
class IdTableCell:UITableViewCell, UITextFieldDelegate, UIAlertViewDelegate{
    
    
    @IBOutlet weak var inputIdTF: UITextField!
    @IBOutlet weak var idDoubleCheckBtn: UIButton!
    
    var delegate:IdTableCellProtocol?
    let serviceUrl = UrlData()
    var idChangeCheck:Bool = false
    var idCheckStrResult:String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        idDoubleCheckBtn.layer.cornerRadius = 10
        inputIdTF.attributedPlaceholder = NSAttributedString(string: "6-15자리,특수X",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let user_id = Data_SignUp.shared.signUp_User_Id
        if user_id.isEmpty && user_id == "" {
            self.inputIdTF.isUserInteractionEnabled = true
        }
        
        cellSetting()
        inputIdTF.delegate = self
        inputIdTF.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 아이디 중복 체크
    @IBAction func idDoubleCheck(_ sender: AnyObject) {
        let idCheckStr = inputIdTF.text!
        if checkID(idCheckStr) == false { // 영문 + 숫자 조합 체크 , true = 조합성공 false = 조합실패
            Data_SignUp.shared.signUp_IdStrCheckResult = "0"
            idCheckStrResult = "0"
            self.delegate?.signUpIdCheck(signUpIdCheck: self)
            return
        } else if checkID(idCheckStr) == true {
            if checkID2(idCheckStr) == true {
                Data_SignUp.shared.signUp_IdStrCheckResult = "1"
                idCheckStrResult = "1"
            } else {
                Data_SignUp.shared.signUp_IdStrCheckResult = "2" // 정규식 체크 성공
                idCheckStrResult = "2"
            }
        }
        guard let user_id = inputIdTF.text else { return }
        do {
            
            let url = serviceUrl.realServiceUrl + "/onepay/rest/idCheck"
            let param: Parameters = [
                "user_id": user_id,
                ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    
                    if String(describing: (jsonObject["resultCode"]!)) == "0" || self.idCheckStrResult != "2" {
                        print("아이디 등록 불가능")
                        Data_SignUp.shared.signUp_IdCheckResult = "fail"
                        self.delegate?.signUpIdCheck(signUpIdCheck: self)
                    } else if String(describing: (jsonObject["resultCode"]!)) == "1" && self.idCheckStrResult == "2" {
                        print("아이디 등록 가능")
                        self.idChangeCheck = true
                        Data_SignUp.shared.signUp_User_Id = self.inputIdTF.text!
                        Data_SignUp.shared.signUp_IdCheckResult = "success"
                        self.delegate?.signUpIdCheck(signUpIdCheck: self)
                    } else {
                        print("등록실패")
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    // 알림 메세지 커스텀
    func configureAppearance() {
        let appearance = ToastView.appearance()
        appearance.backgroundColor = .lightGray
        appearance.textColor = .black
        appearance.font = .boldSystemFont(ofSize: 20)
        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        appearance.bottomOffsetPortrait = 100
        appearance.cornerRadius = 20
    }
    
    // 기본 셀 셋팅
    func cellSetting(){
        inputIdTF.borderStyle = .none
        inputIdTF.keyboardType = .asciiCapable
        inputIdTF.clearButtonMode = .whileEditing
        inputIdTF.autocorrectionType = UITextAutocorrectionType.no
        inputIdTF.spellCheckingType = UITextSpellCheckingType.no
        
    }
    
    // 리턴키 눌렀을때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputIdTF.resignFirstResponder()
        return true
    }
    
    
    
    // 텍스트 필드의 내용이 변경될 때 호출 + 입력 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 15
    }
    
    // 아이이디 영어 + 숫자 포함 체크
    func checkID(_ pw: String) -> Bool {
        let check = "^(?=.*[a-zA-Z])(?=.*[0-9]).{6,15}$"
        let match: NSRange = (pw as NSString).range(of: check, options: .regularExpression)
        if NSNotFound == match.location {
            return false
        }
        return true
    }
    
    // 아이디 특수문자 체크
    func checkID2(_ pw: String) -> Bool {
        let check = "^(?=.*[!@#$&*])"
        let match: NSRange = (pw as NSString).range(of: check, options: .regularExpression)
        if NSNotFound == match.location {
            return false
        }
        return true
    }
    
    // 아이디 중복확인 성공후 텍스트 필드 내용 변경 될때 아이디 검사
    @IBAction func strChanged(_ sender: Any) {
        let user_id = Data_SignUp.shared.signUp_User_Id
        let str = inputIdTF?.text
        if idChangeCheck == true {
            if user_id != str {
                Data_SignUp.shared.signUp_IdCheckResult = "fail"
                
            }
        }
    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
}




