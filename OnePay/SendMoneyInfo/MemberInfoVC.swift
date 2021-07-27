//
//  MemberInfoVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 9..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class MemberInfoVC: UIViewController {

    @IBOutlet weak var memberInfoSlideBtnoutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.

            self.memberInfoSlideBtnoutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
