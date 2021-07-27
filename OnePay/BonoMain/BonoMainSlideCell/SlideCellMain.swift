//
//  slideCellMain.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 5..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

protocol SlideCellMainProtocol {
    func slideCellMain(slideCellMain : SlideCellMain)
}

class SlideCellMain: UITableViewCell {

    @IBOutlet weak var slideCellMainMyInfoImgBtnOutlet: UIButton!
    @IBOutlet weak var goTofeesPayBtnOutlet: UIButton!
    @IBOutlet weak var slideCellMainUserNameLabel: UILabel!
    @IBOutlet weak var slideCellMainUserEmailLabel: UILabel!
 
    var delegate:SlideCellMainProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let feesPayCheck = Data_FeesPay.shared.duesAmount
        let user_name = Data_MemberInfo.shared.user_name
        let user_email = Data_MemberInfo.shared.user_email
        slideCellMainUserNameLabel?.text = user_name
        slideCellMainUserEmailLabel?.text = user_email
        
        // 월 이용료 결제 유무 표시
        if feesPayCheck != "" {
            goTofeesPayBtnOutlet.isEnabled = .init(false)
            
            goTofeesPayBtnOutlet.layer.cornerRadius = 5
            goTofeesPayBtnOutlet.setTitle("✔︎ 서비스이용가능", for: .normal)
        } else {
            goTofeesPayBtnOutlet.isEnabled = .init(true)
            
            goTofeesPayBtnOutlet.layer.cornerRadius = 5
            goTofeesPayBtnOutlet.setTitle("✘ 서비스이용불가", for: .normal)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // 회원정보수정 뷰 이동
    @IBAction func goToMemberInfoBtn(_ sender: Any) {
        Data_Default.shared.slideCellMainGotoValue = "1"
        self.delegate?.slideCellMain(slideCellMain: self)
    }
    
    // 이용료납부 뷰 이동
    @IBAction func goTofeesPayBtn(_ sender: Any) {
        Data_Default.shared.slideCellMainGotoValue = "2"
        self.delegate?.slideCellMain(slideCellMain: self)
    }

}

