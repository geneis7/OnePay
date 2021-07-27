//
//  FirstNaviViewController.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 3. 14..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire

class FirstNaviViewController: UIViewController {
    
    let ud = UserDefaults.standard
    var autoLogin_Result:String = ""
    var autoLogin_Member_Srl:String = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 자동 로그인 체크 : 자동로그인 값 과 멤버 srl 이 없으면 자동로그인 금지
        if let autoLogin_Check = ud.string(forKey: "Auto_Login_Result"){
            autoLogin_Result = autoLogin_Check
        } else {
            autoLogin_Result = ""
        }
        
        if let autoLogin_Srl_Check = ud.string(forKey: "Auto_Login_member_srl"){
            autoLogin_Member_Srl = autoLogin_Srl_Check
        } else {
            autoLogin_Member_Srl = ""
        }

        if autoLogin_Result != "" &&  autoLogin_Member_Srl != ""{
            Data_MemberInfo.shared.member_srl = ud.string(forKey: "Auto_Login_member_srl")!
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_CardInfo")
                self.navigationController?.pushViewController(nextVC!, animated: true)
                ServerTrans_MemberInfoLoad.shared.loginMemberInfoLoad()
                ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
            }
        } else {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginStoryID")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var darkMode = false
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }

}
