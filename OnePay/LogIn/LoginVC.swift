//
//  LoginVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 11..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SCrypto
import SwiftyJSON



@available(iOS 10.0, *)
class LoginVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var logInBonoImage: UIImageView!
    @IBOutlet weak var inputLoginIdTF: UITextField!
    @IBOutlet weak var inputLoginPassTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordLable: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    let ud = UserDefaults.standard
    let serviceUrl = UrlData()
    var user_id:String = ""
    var password:String = ""
    var autoLogin_Result:String = ""
    var checkStatus = false
    //    var keyBoardHeight:CGFloat = 0
    //    var keyCheck:Bool = true
    
    override func viewDidLoad() {

        if let autoLogin_Check = ud.string(forKey: "Auto_Login_Result"){
            autoLogin_Result = autoLogin_Check
        } else {
            ud.set("", forKey: "Auto_Login_Result")
        }
        
        if let autoLogin_user_id = ud.string(forKey: "Auto_Login_user_id"){
            ud.set(user_id, forKey: "Auto_Login_user_id")
            user_id = autoLogin_user_id
        } else {
            ud.set("", forKey: "Auto_Login_user_id")
        }
        
        if let autoLogin_password = ud.string(forKey: "Auto_Login_user_password"){
            password = autoLogin_password
            ud.set(password, forKey: "Auto_Login_user_password")
        } else {
            ud.set("", forKey: "Auto_Login_user_password")
        }
        
        // 입력칸 띄우기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.inputLoginIdTF.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.inputLoginPassTF.frame.height))
        
        inputLoginIdTF.leftView = paddingView
        inputLoginIdTF.leftViewMode = UITextField.ViewMode.always
        inputLoginPassTF.leftView = paddingView2
        inputLoginPassTF.leftViewMode = UITextField.ViewMode.always
    
        
        super.viewDidLoad()
        
        self.inputLoginIdTF.delegate = self
        self.inputLoginPassTF.delegate = self
        logInSettings()
        // Do any additional setup after loading the view.
        
        // 자동로그인 체크
        if user_id != "" && password != "" && autoLogin_Result == "1" {
            if user_id == "" && password == "" && autoLogin_Result == "1" {
                checkStatus = false
                checkBoxBtn.setImage(#imageLiteral(resourceName: "img_unchecked"), for: .normal)
                checkBoxBtn.backgroundColor = .clear
                ud.set("", forKey: "Auto_Login_Result")
                return
            }
            
            do {
                let url = serviceUrl.realServiceUrl + "/onepay/rest/logIn"
                let param: Parameters = [
                    "user_id": user_id,
                    "password" : password
                ]
                let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
                alamo.responseJSON() { response in
                    
                    if let jsonObject = response.result.value as? [String: Any] {
                        
                        if String(describing: (jsonObject["resultCode"]!)) == "1"{
                            

                            Data_MemberInfo.shared.member_srl = jsonObject["resultCode"]! as! String
                            print("자동 로그인 성공")
                            print("member_srl = \(jsonObject["member_srl"]!)")
                            
                            ServerTrans_MemberInfoLoad.shared.loginMemberInfoLoad()
                            ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
                            
                            
                            let when = DispatchTime.now() + 0.5
                            DispatchQueue.main.asyncAfter(deadline: when) {
                                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                                self.navigationController?.pushViewController(nextVC!, animated: true)
                            }
                            
                        } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                            self.displayMsg(title: "원페이", msg: "자동로그인 실패.")
                        }
                        print("resultCode = \(jsonObject["resultCode"]!)")
                        print("resultMessage = \(jsonObject["resultMessage"]!)")
                        
                    }
                }
                
            }
                
        }
    }
    
//    @objc func keyboardWillShow(_ sender: Notification) {
//        let info = sender.userInfo
//        let kbSize: CGSize? = (info?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size
//        var bkgndRect: CGRect = self.view.frame
//        bkgndRect.size.height -= (kbSize?.height)!
//
//        let keyHeight:CGFloat = (kbSize?.height)!
//
//        self.view.frame.origin.y -= keyHeight
//    }
//
//    @objc func keyboardWillHide(_ sender: Notification) {
//        self.view.frame.origin.y = 0 // Move view to original position
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // check 박스 액션에 따른 이벤트
    @IBAction func checkBoxTouched(_ sender: UIButton) {
        if checkStatus == false {
            checkStatus = true
            checkBoxBtn.setImage(#imageLiteral(resourceName: "img_checked"), for: .normal)
            checkBoxBtn.backgroundColor = .white
            ud.set("1", forKey: "Auto_Login_Result")
            print("1")
        } else if checkStatus == true {
            checkStatus = false
            checkBoxBtn.setImage(#imageLiteral(resourceName: "img_unchecked"), for: .normal)
            checkBoxBtn.backgroundColor = .clear
            ud.set("", forKey: "Auto_Login_Result")
            print("2")
        }
    }

    // 약관 페이지 이동
    @IBAction func signUpBtnTouched(_ sender: UIButton) {
        inputLoginIdTF?.text = ""
        inputLoginPassTF?.text = ""
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "AcceptTermsStoryID")
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    // 로그인 버튼
    @IBAction func loginBtn(_ sender: UIButton) {
        // 패스워드 암호화
        let sha256 = inputLoginPassTF.text?.SHA256()
        
        guard let user_id = inputLoginIdTF.text else { return }
        guard let password = sha256 else { return }
        
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/logIn"
            let param: Parameters = [
                "user_id": user_id,
                "password" : password
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        if self.checkStatus == true {
                            self.ud.set("1", forKey: "Auto_Login_Result")
                            self.ud.set(user_id, forKey: "Auto_Login_user_id")
                            self.ud.set(password, forKey: "Auto_Login_user_password")
                            self.ud.set(jsonObject["member_srl"]!, forKey: "Auto_Login_member_srl")
                        }
                        
                        let member_srl = (jsonObject["member_srl"]!)
                        Data_MemberInfo.shared.member_srl = "\(member_srl)"
                        Data_MemberInfo.shared.origin_password = password
                        ServerTrans_MemberInfoLoad.shared.loginMemberInfoLoad()
                        ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
                        
      

                        print("로그인 성공")
                        
                        let when = DispatchTime.now() + 0.5
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                            self.navigationController?.pushViewController(nextVC!, animated: true)
                        }
                        
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {

                        self.displayMsg(title: "로그인 실패", msg: "아이디와 패스워드를 확인해주세요.")
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                    
                }
            }
        }
    }
    
    // 리턴키 눌렀을때 자동 줄바꿈
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputLoginIdTF.resignFirstResponder()
        inputLoginPassTF.resignFirstResponder()

        return true
    }
    
    func logInSettings(){
        _ = UIColor(hexString: "#C39B45")
        
        idLabel.isHidden = true
        passwordLable.isHidden = true
        view.backgroundColor = UIColor.newColor_Green
        
        // 로그인 버튼 셋팅
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // 폰트 굵기 설정
        loginBtn.titleLabel?.textColor = .white // 로그인 버튼 텍스트 컬러
        loginBtn.backgroundColor = UIColor.newColor_Blue // 로그인 버튼 백그라운드 컬러
        loginBtn.layer.cornerRadius = 10
        
        // 회원가입 버튼 셋팅
        
        signUpBtn.layer.cornerRadius = 10
        signUpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // 폰트 굵기 설정
        signUpBtn.titleLabel?.textColor = .white // 회원가입 버튼 텍스트 색상
        signUpBtn.backgroundColor = UIColor.newColor_Gray // 회원가입 버튼 백그라운드 컬러
        
        
        // id 텍스트 필드 셋팅
        inputLoginIdTF.clearButtonMode = .whileEditing // 텍스트 입력시 삭제 버튼 표시 설정
        inputLoginIdTF.autocorrectionType = UITextAutocorrectionType.no // 문자열 자동완성 끔
        inputLoginIdTF.spellCheckingType = UITextSpellCheckingType.no // 단어 자동 수정 끔
        inputLoginIdTF.returnKeyType = .default // 키보드 리턴키 타입
        inputLoginIdTF.borderStyle = .none // 테두리 스타일
        inputLoginIdTF.keyboardType = .default
        inputLoginIdTF.backgroundColor = .clear
        inputLoginIdTF.attributedPlaceholder = NSAttributedString(string: "아이디",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        // pass 텍스트 필드 셋팅

        inputLoginPassTF.clearButtonMode = .whileEditing
        inputLoginPassTF.autocorrectionType = UITextAutocorrectionType.no
        inputLoginPassTF.spellCheckingType = UITextSpellCheckingType.no
        inputLoginPassTF.isSecureTextEntry = true
        inputLoginPassTF.returnKeyType = .default
        inputLoginPassTF.borderStyle = .none
        inputLoginPassTF.keyboardType = .default
        inputLoginPassTF.backgroundColor = .clear
        inputLoginPassTF.attributedPlaceholder = NSAttributedString(string: "비밀번호",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // 텍스트 필드 밑줄
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: inputLoginIdTF.frame.size.height - width, width:  inputLoginIdTF.frame.size.width, height: inputLoginIdTF.frame.size.height)
        border.borderWidth = width
        inputLoginIdTF.layer.addSublayer(border)
        inputLoginIdTF.layer.masksToBounds = true
        
        let border2 = CALayer()
        let width2 = CGFloat(1.0)
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: inputLoginPassTF.frame.size.height - width2, width:  inputLoginPassTF.frame.size.width, height: inputLoginPassTF.frame.size.height)
        border2.borderWidth = width2
        inputLoginPassTF.layer.addSublayer(border2)
        inputLoginPassTF.layer.masksToBounds = true
    }
    
    
    
    
    @IBAction func idEditStart(_ sender: Any) {
        if inputLoginIdTF.text == "" {
            inputLoginIdTF.placeholder = ""
        }
            idLabel.isHidden = false
        self.view.frame.origin.y = -216
    }
    
    
    @IBAction func idEditEnd(_ sender: Any) {
        self.view.frame.origin.y = 0
        if inputLoginIdTF?.text != "" {
            idLabel.isHidden = false
        } else if inputLoginIdTF?.text == "" {
            idLabel.isHidden = true
            inputLoginIdTF.attributedPlaceholder = NSAttributedString(string: "아이디",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        
    }
    
    
    @IBAction func passEditStart(_ sender: Any) {
        if inputLoginPassTF.text == "" {
            inputLoginPassTF.placeholder = ""
        }
            passwordLable.isHidden = false
        self.view.frame.origin.y = -216
    }
    
    @IBAction func passEditEnd(_ sender: Any) {
        if inputLoginPassTF?.text != "" {
            passwordLable.isHidden = false
        } else if inputLoginPassTF?.text == ""{
            passwordLable.isHidden = true
            inputLoginPassTF.attributedPlaceholder = NSAttributedString(string: "비밀번호",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        self.view.frame.origin.y = 0
    }
    
    
}


