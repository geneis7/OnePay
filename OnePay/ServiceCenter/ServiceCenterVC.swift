//
//  ServiceCenterVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 8..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ServiceCenterVC: UIViewController {

    @IBOutlet weak var serviceCenterslideMenuBtn: UIButton!
    @IBOutlet var serviceCenterView: UIView!
    @IBOutlet weak var btn_SendCall: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_SendCall.layer.cornerRadius = 10
        
        serviceCenterView.onSwipeRight{ _ in
            self.navigationController?.popViewController(animated: true)
        }
            

        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            
            self.serviceCenterslideMenuBtn.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)

            // 제스처를 뷰에 추가한다.
//            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
            self.view.addGestureRecognizer(revealVC.tapGestureRecognizer())
        }
            
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 콜 센터 전화 하기 버튼
    @IBAction func callCenterBtn(_ sender: Any) {
        let url = NSURL(string: "tel://07044373427")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
