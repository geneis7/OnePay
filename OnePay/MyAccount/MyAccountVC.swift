//
//  MyAccountVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 8..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit


class MyAccountVC: UIViewController {

    @IBOutlet weak var myAccountSlideMenuBtnOutlet: UIButton!
    @IBOutlet weak var btn_AccountSubmit: UIButton!
    @IBOutlet var myAccountView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_AccountSubmit.layer.cornerRadius = 10
        myAccountView.onSwipeLeft{ _ in
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_ChargeHistory")
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }

        myAccountView.onSwipeRight{ _ in
            self.navigationController?.popViewController(animated: true)

        }
        
        
        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            
            self.myAccountSlideMenuBtnOutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(revealVC.tapGestureRecognizer())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func makeAccountBtn(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ElectronicFinanceStoryID")

        self.navigationController?.pushViewController(nextVC!, animated: true)
    }

}
