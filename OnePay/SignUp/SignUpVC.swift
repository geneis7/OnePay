//
//  SignUpVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 13..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit

protocol ChangeCountryLableProtocol {
    func changeCountryData(data : String)
}

protocol ChangeBankNameLableProtocol {
    func changeBankNameLableProtocol(ChangeBankNameLableProtocol : SignUpVC)
}

protocol ChangeBranchLableProtocol {
    func changeBranchLableProtocol(changeBranchLableProtocol : String)
}



class SignUpVC: UIViewController , UITableViewDataSource , UITableViewDelegate ,UITextFieldDelegate , ResultProtocol, BranchNameProtocol,IdTableCellProtocol,CountryTableCellProtocol,PhoneNumberTableCellProtocol,RecommenderIdTableCellProtocol,AuthTableCellProtocol {
    
    @IBOutlet weak var logInTableView: UITableView!
    let branchCell = BranchNameTableCell()
    var delegate:ChangeCountryLableProtocol?
    var bankDelegate:ChangeBankNameLableProtocol?
    var branchDelegate:BranchNameProtocol?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.logInTableView.delegate = self
        self.logInTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // 셀 로우 섹션 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }

    
    
    // 각각의 셀 커스텀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 회원가입 -> 본인인증 셀
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableCell") as! AuthTableCell
            
            cell.delegate = self
            
            return cell
        }
            
            // 회원가입 -> 본인인증 id 중복확인 셀
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IdTableCell") as! IdTableCell
            cell.delegate = self
            return cell
        }
            
            // 회원가입 -> 비밀번호 입력 셀
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassTableCell") as! PassTableCell
            
            return cell
        }
            
            // 회원가입 -> 비밀번호 재입력 셀
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmPassTableCell") as! ConfirmPassTableCell
            
            return cell
        }
  
            // 회원가입 -> 한글 이름 입력 셀
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KorNameTableCell") as! KorNameTableCell
            
            return cell
        }
            
            // 회원가입 -> 영어 이름 입력 셀
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EngNameTableCell") as! EngNameTableCell
            
            return cell
        }
            
            // 회원가입 -> 지점명 선택 셀
        else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BranchNameTableCell") as! BranchNameTableCell
            
            cell.branchDelegate = self
            
            return cell
        }
            
            // 회원가입 -> 국적 선택 셀
        else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell") as! CountryTableCell
            
            cell.delegate = self
            
            return cell
        }
            
            // 회원가입 -> 생년월일 입력 셀
        else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateOfBirthTableCell") as! DateOfBirthTableCell
            
            return cell
        }
            
            // 회원가입 -> 성별 선택 셀
        else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenderTableCell") as! GenderTableCell
            
            return cell
        }
            
            // 회원가입 -> 이메일주소 입력 셀
        else if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailTableCell") as! EmailTableCell
            
            return cell
        }
            
            // 회원가입 -> 휴대폰번호 입력 셀
        else if indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumberTableCell") as! PhoneNumberTableCell
            
            cell.delegate = self
            
            return cell
        }
            
            // 회원가입 -> 추천인 아이디 선택 셀
        else if indexPath.row == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommenderIdTableCell") as! RecommenderIdTableCell
            
            cell.delegate = self
            
            return cell
        }
            
            // 회원가입 -> 회원가입 완료 셀
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpCompleteTableCell") as! SignUpCompleteTableCell
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.logInTableView.reloadData()
        }
    }
    
    @IBAction func signUpBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 프로토콜을 회원가입 완료 버튼
    func signUpComplete(signUpComplete: SignUpCompleteTableCell) {
        print("//---------->    회원가입 submit    <----------//")
        let alertTitle = "원페이"
        var alertMessage = ""
        let idCheckResult = Data_SignUp.shared.signUp_IdCheckResult
        let passCheckResult1 = Data_SignUp.shared.signUp_PassCheck1
        let passCheckResult2 = Data_SignUp.shared.signUp_PassCheck2
        let passCheckResult3 = Data_SignUp.shared.signUp_Confirm_PassCheck1
        let passCheckResult4 = Data_SignUp.shared.signUp_Confirm_PassCheck2
        let phoneAuthResult = Data_SignUp.shared.signUp_PhoneAuthResult
        let push_id_result = Data_SignUp.shared.signUp_User_PushId_Result
        let user_phone_result = Data_SignUp.shared.signUp_User_PhoneNumber_Result
        let signup_success_result = Data_SignUp.shared.signUp_Success_Result
        
        let user_id = Data_SignUp.shared.signUp_User_Id
        let password = Data_SignUp.shared.signUp_Password
        let signUpConfirmPass = Data_SignUp.shared.signUp_Confirm_Password
        let user_name = Data_SignUp.shared.signUp_User_Name
        let eng_name = Data_SignUp.shared.signUp_User_EngName
        let branch_name = Data_SignUp.shared.signUp_Select_Branch_Code
        let user_nation_name = Data_SignUp.shared.signUp_User_Nation_Code
        let user_birth = Data_SignUp.shared.signUp_User_Birth
        let user_gender = Data_SignUp.shared.signUp_User_Gender
        let user_email = Data_SignUp.shared.signUp_User_Email
        let user_phone = Data_SignUp.shared.signUp_User_PhoneNumber
        let push_id = Data_SignUp.shared.signUp_User_PushId

        if phoneAuthResult != "success" {
            alertMessage = "휴대폰 본인인증을 해주세요."
        } else if user_id.isEmpty && user_id == "" || idCheckResult == "fail" {
            alertMessage = "아이디를 확인해주세요."
        } else if password.isEmpty || password == "" || passCheckResult1 == "false" || passCheckResult2 == "true"{
            alertMessage = "비밀번호 6-15자리, 영문+숫자 조합을 확인해주세요.(특수X)"
        } else if signUpConfirmPass.isEmpty || signUpConfirmPass == "" || passCheckResult3 == "false" || passCheckResult4 == "true" {
            alertMessage = "비밀번호확인 6-15자리, 영문+숫자 조합을 확인해주세요.(특수X)"
        } else if password != signUpConfirmPass{
            alertMessage = "비밀번호 재 확인이 일치 하지 않습니다."
        } else if user_name.isEmpty || user_name == "" {
            alertMessage = "한글이름을 확인해주세요."
        } else if eng_name.isEmpty || eng_name == "" {
            alertMessage = "영문이름을 확인해주세요."
        } else if branch_name.isEmpty || branch_name == "" {
            alertMessage = "지점를 확인해주세요."
        } else if user_nation_name.isEmpty || user_nation_name == "" {
            alertMessage = "국가를 확인해주세요."
        } else if user_birth.isEmpty || user_birth == "" || user_birth.count > 6  {
            alertMessage = "생년월일을 확인해주세요."
        } else if user_gender.isEmpty || user_gender == ""  {
            alertMessage = "성별을 확인해주세요."
        } else if user_email.isEmpty || user_email == "" || user_email == "fail"  {
            alertMessage = "이메일을 확인해주세요."
        } else if user_phone.isEmpty || user_phone == "" || user_phone_result != "success" {
            alertMessage = "휴대폰번호를 확인해주세요."
        } else if push_id.isEmpty || push_id == "" || push_id_result != "success"  {
            alertMessage = "추천인을 확인해주세요."
        } else if signup_success_result == "success" {
            alertMessage = "회원가입이 완료 되었습니다."
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            
            if alertMessage == "회원가입이 완료 되었습니다." {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginStoryID")
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
        }
        
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
    func countryName(countryName: CountryTableCell) {
        print("//---------->  국가 선택  <----------//")
        
        let contentVC = CountryListTableViewController()
        contentVC.delegate = self
        
        // 경고창 객체를 생성하고, OK 및 Cancel 버튼을 추가한다.
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: .alert)
        
        // 컨트롤 뷰 컨트롤러를 알림창에 등록한다.
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        
        let okAction = UIAlertAction(title: "확인", style: .default){
            UIAlertAction in
            DispatchQueue.main.async {
                self.logInTableView.reloadData()
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: false)
        
        
    }
    
    // 키보드 올릴때 화면 업
    @objc func keyboardWillShow(_ sender: Notification) {
        let indexPathNum = Data_Default.shared.IndexPathNum

        
        let info = sender.userInfo
        let kbSize: CGSize? = (info?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size
        var bkgndRect: CGRect = self.view.frame
        bkgndRect.size.height -= (kbSize?.height)!
        
        let keyHeight:CGFloat = (kbSize?.height)!

        let deviceModelName = UIDevice.current.modelName
        
        let viewy = self.view.frame.origin.y
        
        if viewy == 0 && indexPathNum != "" {
            if deviceModelName == "iPhone X" && indexPathNum == "numpad" {
                self.view.frame.origin.y -= (kbSize?.height)!
                print("아이폰 엑스")
            } else  {
                self.view.frame.origin.y -= (kbSize?.height)!
                print("기타 기종")
            }
        }
        
        print(":::::::::::::::::::::::::")
        print(keyHeight)
        print(indexPathNum)
        print(UIDevice.current.modelName)

        
    }
    
    // 키보드 올릴때 화면 다운
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
        Data_Default.shared.IndexPathNum = ""
    }
    
    
    // 휴대폰 번호 중복 체크
    func phoneNumberCheck(phoneNumberCheck: PhoneNumberTableCell) {
        print("//---------->  휴대폰 번호 확인  <----------//")
        var alertTitle = ""
        let phoneNum = Data_SignUp.shared.signUp_User_PhoneNumber
        let phoneNumCheckResult = Data_SignUp.shared.signUp_User_PhoneNumber_Result
 
        if phoneNumCheckResult == "fail" || phoneNum.count < 10 {
            alertTitle = "휴대폰번호를 확인해주세요."
        } else if phoneNumCheckResult == "success" && phoneNum.count > 9 {
            alertTitle = "휴대폰등록이 가능합니다."
        }
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
    
    // 추천인 확인
    func recommenderIdCheck(recommenderIdCheck: RecommenderIdTableCell) {
        print("//---------->  추천인 확인  <----------//")
        
        var alertTitle = ""
        let recommenderIdCheck = Data_SignUp.shared.signUp_User_PushId_Result
        
        if recommenderIdCheck == "fail" {
            alertTitle = "추천인을 확인해주세요."
        } else if recommenderIdCheck == "success" {
            alertTitle = "추천인등록이 가능합니다."
        }
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
    func authTableCell(authTableCell: AuthTableCell) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneAuthStoryID")
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    

    // 프로토콜을 이용한 아이디 중복 체크 얼럿
    func signUpIdCheck(signUpIdCheck: IdTableCell) {
        print("//---------->  아이디 중복 체크  <----------//")
        let alertTitle = "원페이"
        var alertMessage = ""
        let idCheck = Data_SignUp.shared.signUp_IdStrCheckResult
        let idCheckResult = Data_SignUp.shared.signUp_IdCheckResult
        
        if idCheck == "0" {
            alertMessage = "영문,숫자 조합 6-15 자리를 확인해주세요."
        } else if idCheck == "1" {
            alertMessage = "특수문자를 제외 시켜 주세요."
        } else if idCheckResult == "fail"{
            alertMessage = "등록된 아이디 입니다."
        } else if idCheck == "2" && idCheckResult == "success" {
            alertMessage = "회원가입이 가능한 아이디 입니다."
        } else {
            alertMessage = "아이디를 다시 확인해 주세요."
        }
        
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            let alert = UIAlertController(title: alertTitle , message: alertMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: false)
        }
    }
    
    // 프로토콜을 이용한 지점명 선택 얼럿
    func branchName(branchName: BranchNameTableCell) {
        print("//---------->    지점선택 얼럿  <----------//")
        let contentVC = BranchListTableViewController()
        contentVC.delegate = self
        
        // 경고창 객체를 생성하고, OK 및 Cancel 버튼을 추가한다.
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: .alert)
        
        // 컨트롤 뷰 컨트롤러를 알림창에 등록한다.
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        
        let okAction = UIAlertAction(title: "확인", style: .default){
            UIAlertAction in
            
            DispatchQueue.main.async {
                self.logInTableView.reloadData()
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: false)
    }
    
}
