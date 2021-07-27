//
//  SendMoneySuccessVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 24..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SendMoneySuccessVC: UIViewController {
    
    let serviceUrl = UrlData()
    @IBOutlet weak var btn_SendMoneyComplete: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_SendMoneyComplete.layer.cornerRadius = 10
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccountHave")
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
}
