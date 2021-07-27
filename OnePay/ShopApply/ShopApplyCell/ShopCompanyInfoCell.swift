//
//  ShopCompanyInfoCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ShopCompanyInfoCell: UITableViewCell , UITextViewDelegate{

    @IBOutlet weak var inputShopCompanyInfoCellTextView: UITextView!
    @IBOutlet weak var shopCompanyInfoPlaceholderLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputShopCompanyInfoCellTextView.delegate = self
        cellSetting()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 기본 셀 셋팅
    func cellSetting(){
        subLabel.isHidden = true
        inputShopCompanyInfoCellTextView.keyboardType = .default
        inputShopCompanyInfoCellTextView.autocorrectionType = UITextAutocorrectionType.no
        inputShopCompanyInfoCellTextView.spellCheckingType = UITextSpellCheckingType.no
        inputShopCompanyInfoCellTextView.returnKeyType = .next
        inputShopCompanyInfoCellTextView.clearsOnInsertion = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("기업소개 :::::::::::::::::::::::")
        if (text == "\n") {
            textView.resignFirstResponder()
        } else {
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        Data_ShopApply.shared.shopApply_IndexPathNum = "keypad"
        subLabel.isHidden = false
        shopCompanyInfoPlaceholderLabel.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = self.inputShopCompanyInfoCellTextView?.text
        if text != "" {
            self.subLabel.isHidden = false
            Data_ShopApply.shared.shopApply_CompanyInfo = text!
        } else {
            self.subLabel.isHidden = true
            shopCompanyInfoPlaceholderLabel.isHidden = false
            
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        Data_ShopApply.shared.shopApply_IndexPathNum = "keypad"
        inputShopCompanyInfoCellTextView.textColor = .white
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("텍스트 뷰 엔드 2")
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
        inputShopCompanyInfoCellTextView.textColor = .white
        return true
    }
    
}
