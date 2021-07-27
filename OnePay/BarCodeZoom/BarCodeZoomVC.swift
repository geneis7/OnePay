//
//  BarCodeZoomVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 25..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit


class BarCodeZoomVC: UIViewController {
    
    @IBOutlet weak var barCodeZoomStatusLabel: UILabel!
    @IBOutlet weak var barCodeZoomImageView: UIImageView!
    var filter:CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barCodeZoomStatusLabel.text = "등록된 카드가 없습니다."
        barCodeGenerate()
        
        // 화면 터치 이벤트
        view.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        view.addGestureRecognizer(tapRecognizer)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 바코드 뷰 터치 이벤트
    @objc func imageViewTapped(imageView:UITapGestureRecognizer? = nil ) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 가상계좌 번호를 바코드로 변환
    func barCodeGenerate(){
        
        let user_phone = Data_MemberInfo.shared.user_phone

        if user_phone != "" {
            
            let text = user_phone
            let data = text.data(using: .ascii, allowLossyConversion: false)
            filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))

            barCodeZoomImageView.image = image
            barCodeZoomStatusLabel.text = ""
        }
        
    }
    
    
}
