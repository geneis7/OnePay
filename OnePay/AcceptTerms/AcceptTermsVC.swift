//
//  AcceptTermsVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 12..
//  Copyright © 2017년 유하늘. All rights reserved.
//  ### 이용약관 뷰 컨트롤러 ###

import UIKit

class AcceptTermsVC: UIViewController {
    
    @IBOutlet weak var acceptTermsTV: UITextView!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var btn_AcceptOK: UIButton!
    
    
    
    var checkStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        acceptTermsTV.isEditable = false
        btn_AcceptOK.layer.cornerRadius = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 약관동의뷰 뒤로가기버튼
    @IBAction func acceptTermsBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // check 박스 액션에 따른 이벤트
    @IBAction func checkBoxTouched(_ sender: UIButton) {
        if checkStatus == false {
            checkStatus = true
            checkBoxBtn.setImage(#imageLiteral(resourceName: "img_checked"), for: .normal)
        } else if checkStatus == true {
            checkStatus = false
            checkBoxBtn.setImage(#imageLiteral(resourceName: "img_unchecked"), for: .normal)
        }
    }
    
    // 약관동의후 회원가입 페이지 이동 버튼
    @IBAction func acceptTermsConfirm(_ sender: UIButton) {
        if checkStatus == false {
            displayMsg(title: "원페이", msg: "개인정보 취급 정책에 동의하셔야 합니다.")
        } else if checkStatus == true {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SignUpStoryID")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
    }
}
