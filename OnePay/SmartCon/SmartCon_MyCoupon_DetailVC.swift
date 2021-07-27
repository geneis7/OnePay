//
//  SmartCon_MyCoupon_DetailVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 4. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SmartCon_MyCoupon_DetailVC: UIViewController {
    
    @IBOutlet weak var myCoupon_image: UIImageView!
    @IBOutlet weak var myCoupon_Status: UILabel!
    @IBOutlet weak var myCoupon_Goods_Name: UILabel!
    @IBOutlet weak var myCoupon_Brand_Name: UILabel!
    @IBOutlet weak var myCoupon_Goods_Price: UILabel!
    @IBOutlet weak var myCoupon_Valid_Start: UILabel!
    @IBOutlet weak var myCoupon_Valid_End: UILabel!
    @IBOutlet weak var myCoupon_Cancel_Period: UILabel!
    @IBOutlet weak var myCoupon_Cancel_Btn: UIButton!
    
    var myCon_Vali_Detail_Data:[String] = []
    var uniqueTime:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmmss"
        let time = formatter.string(from: currentDate)
        uniqueTime = time
        
        
        
        // 화면 터치 이벤트
        view.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewTapped))
        view.addGestureRecognizer(tapRecognizer)
        
        myCon_Vali_Detail_Data = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_Detail_Data
        
        let nowTime:Int = Int(uniqueTime)!
        let endTime:Int = Int(myCon_Vali_Detail_Data[3])!
        
        if myCon_Vali_Detail_Data[7] == "1"{
            myCoupon_Status.text? = "사용 완료"
            myCoupon_Cancel_Period.isHidden = true
            myCoupon_Cancel_Btn.isHidden = true
        } else {
            myCoupon_Status.text? = "사용 가능"
            if nowTime > endTime {
                myCoupon_Cancel_Period.isHidden = false
                myCoupon_Cancel_Btn.isHidden = true
            } else {
                myCoupon_Cancel_Btn.isHidden = false
                myCoupon_Cancel_Period.isHidden = false
            }
        }
        
        if myCon_Vali_Detail_Data[8] == "N" {
            myCoupon_Cancel_Btn.isHidden = true
        }
        

        
        for num in 1...3 {
            let str = myCon_Vali_Detail_Data[num]
            
            let monthStartIndex = str.index(str.startIndex, offsetBy: 4)
            let monthEndIndex = str.index(str.startIndex, offsetBy: 6)
            let dayStartIndex = str.index(str.startIndex, offsetBy: 6)
            let dayEndIndex = str.index(str.startIndex, offsetBy: 8)
            let hourStartIndex = str.index(str.startIndex, offsetBy: 8)
            let hourEndIndex = str.index(str.startIndex, offsetBy: 10)
            let minStartIndex = str.index(str.startIndex, offsetBy: 10)
            let minEndIndex = str.index(str.startIndex, offsetBy: 12)
            let secStartIndex = str.index(str.startIndex, offsetBy: 12)
            let secEndIndex = str.index(str.startIndex, offsetBy: 14)
            
            let year = str.prefix(4)
            let month = str[monthStartIndex..<monthEndIndex]
            let day = str[dayStartIndex..<dayEndIndex]
            let hour = str[hourStartIndex..<hourEndIndex]
            let min = str[minStartIndex..<minEndIndex]
            let sec = str[secStartIndex..<secEndIndex]
            let generator_total1:String = year + "년 " + month + "월 " + day + "일"
            let generator_total2:String = hour + "시 " + min + "분 " + sec + "초"
            
            
            
            if num == 1 {
                myCoupon_Valid_Start.text? = "구매일자 : " + "\(generator_total1)" + "\(generator_total2)"
            } else if num == 2 {
                myCoupon_Valid_End.text? = "사용기한 : " + "\(generator_total1)" + "\(generator_total2)"
            } else if num == 3 {
                myCoupon_Cancel_Period.text? = "취소기한 : " + "\(generator_total1)" + "\(generator_total2)"
            }
        }
        
        
        
        myCoupon_Goods_Name.text? = myCon_Vali_Detail_Data[12]
        myCoupon_Brand_Name.text? = myCon_Vali_Detail_Data[11]
        myCoupon_Goods_Price.text? = String(Int(myCon_Vali_Detail_Data[10])!.withComma) + " P"
        
        
        let imgUrl = myCon_Vali_Detail_Data[9]
        let url = URL(string: imgUrl)
        let data = try? Data(contentsOf: url!)
        let imageData = data
        myCoupon_image.image = UIImage(data: imageData!)
        
    }
    
    
    
    // 바코드 뷰 터치 이벤트
    @objc func ViewTapped(imageView:UITapGestureRecognizer? = nil ) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myCoupon_Cancel_Btn(_ sender: Any) {
        
        let title = "원페이 스마트콘"
        let message = "원페이 스마트콘의 구매를 취소하시겠습니까?" + "\n" + "\n" + "구매 취소는 해당 스마트콘 취소기한 내에만 가능합니다."

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let action = UIAlertAction(title: "확인", style: .default) {
            UIAlertAction in
            
            Data_SendMoney.shared.sendMoney_Flag = "myCouponCancel"
            
            
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyPaymentPasswordStoryID")
            
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
    
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left

        let messageText = NSMutableAttributedString(
            string: "원페이 스마트콘의 구매를 취소하시겠습니까?" + "\n" + "\n" + "구매 취소는 해당 스마트콘 취소기한 내에만 가능합니다.",
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor : UIColor.black
                
            ]
        )
        
        alert.setValue(messageText, forKey: "attributedMessage")
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
