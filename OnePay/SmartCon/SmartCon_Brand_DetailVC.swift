//
//  SmartCon_Brand_DetailVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 4. 6..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class SmartCon_Brand_DetailVC: UIViewController{
    
    @IBOutlet weak var brand_Detail_brand_img: UIImageView!
    @IBOutlet weak var brand_Detail_goods_name: UILabel!
    @IBOutlet weak var brand_Detail_brand_name: UILabel!
    @IBOutlet weak var brand_Detail_goods_price: UILabel!
    @IBOutlet weak var brand_Detail_goods_msg: UITextView!
    @IBOutlet weak var brand_Detail_Title_Label: UILabel!
    @IBOutlet weak var brand_Detail_Title_View: UIView!
    
    var select_Brand_goods:[String] = []
    var feesPay_Check = ""
    var cancelCheck = ""
    
    var imgUrl:String = ""
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brand_Detail_Title_View.roundCorners(corners: [.topRight , .topLeft], radius: 30.0)
        
        
        feesPay_Check = Data_FeesPay.shared.duesAmount
        
        select_Brand_goods = Data_SmartCon.shared.smartCon_SelectGoodsInfo
        
brand_Detail_Title_Label.text = self.select_Brand_goods[0]
            self.brand_Detail_goods_name.text? = self.select_Brand_goods[2]
            self.brand_Detail_brand_name.text? = self.select_Brand_goods[0]
            self.brand_Detail_goods_price.text? = String(describing: Int(self.select_Brand_goods[5])!.withComma) + " P"
            self.brand_Detail_goods_msg.text? = self.select_Brand_goods[4]
            self.cancelCheck = self.select_Brand_goods[6]
            
            self.imgUrl = self.select_Brand_goods[3]
            
            let url = URL(string: self.imgUrl)
            let data = try? Data(contentsOf: url!)
            let imageData = data
            
            self.brand_Detail_brand_img.image = UIImage(data: imageData!)
            
            self.brand_Detail_goods_msg.isEditable = false
            self.brand_Detail_goods_msg.isScrollEnabled = false
            self.brand_Detail_goods_msg.dataDetectorTypes = .link
            self.select_Brand_goods.removeAll()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendData(data: Array<Any>) {
        
        
        select_Brand_goods = data as! [String]
    }
    
    
    @IBAction func smartConBuyingBtn(_ sender: Any) {

        if feesPay_Check == "" {
            
            displayMsg(title: "원페이 스마트콘", msg: "월 이용료를 납부 하셔야 사용 가능합니다.")
            
        } else if feesPay_Check != "" {

            if cancelCheck == "N" {

                let title = "원페이 스마트콘"
                let message = "이 상품은 구매하시면 주문취소가 불가능한 상품입니다. 그래도 구매 하시겠습니까?"
                
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "취소", style: .destructive)
                
                let action = UIAlertAction(title: "확인", style: .default) {
                    UIAlertAction in
                    
                    Data_SendMoney.shared.sendMoney_Flag = "smartConPay"
                    
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyPaymentPasswordStoryID")
                    
                    self.navigationController?.pushViewController(nextVC!, animated: true)
                    
                }
                
                
                alert.addAction(cancel)
                alert.addAction(action)

                
                self.present(alert, animated: true, completion: nil)
            } else {
                
                Data_SendMoney.shared.sendMoney_Flag = "smartConPay"
                
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyPaymentPasswordStoryID")
                
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }

        } else {
            displayMsg(title: "원페이 스마트콘", msg: "잠시후 다시 이용해주세요.")
        }
    }
    
}
