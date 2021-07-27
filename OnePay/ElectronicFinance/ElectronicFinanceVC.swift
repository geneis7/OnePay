//
//  ElectronicFinanceVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 9..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ElectronicFinanceVC: UIViewController {


    @IBOutlet weak var checkBoxOneBtn: UIButton!
    @IBOutlet weak var checkBoxTwoBtn: UIButton!
    @IBOutlet weak var btn_ElectronicFinanceSubmit: UIButton!
    
    var checkBoxOneStatus = false
    var checkBoxTwoStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_ElectronicFinanceSubmit.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 가상계좌 이용 약관 체크 이벤트
    @IBAction func checkBoxOneTouched(_ sender: Any) {
        if checkBoxOneStatus == false {
            checkBoxOneStatus = true
            checkBoxOneBtn.setImage(#imageLiteral(resourceName: "img_checked"), for: .normal)
        } else if checkBoxOneStatus == true {
            checkBoxOneStatus = false
            checkBoxOneBtn.setImage(#imageLiteral(resourceName: "img_unchecked"), for: .normal)
        }
    }
    
    // 전자금융거래 이용 약관 체크 이벤트
    @IBAction func checkBoxTwoTouched(_ sender: Any) {
        if checkBoxTwoStatus == false {
            checkBoxTwoStatus = true
            checkBoxTwoBtn.setImage(#imageLiteral(resourceName: "img_checked"), for: .normal)
        } else if checkBoxTwoStatus == true {
            checkBoxTwoStatus = false
            checkBoxTwoBtn.setImage(#imageLiteral(resourceName: "img_unchecked"), for: .normal)
        }
    }
    
    // 전자금융 거래 약관 동의 확인
    @IBAction func acceptTermsConfirm(_ sender: Any) {
        if checkBoxOneStatus == false || checkBoxTwoStatus == false {
            displayMsg(title: "전자금융거래", msg: "이용약관에 동의하셔야 합니다.")
        } else if checkBoxOneStatus == true && checkBoxTwoStatus == true {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BankStoryID")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
    }

    
    @IBAction func backButton(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccount")
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
}
