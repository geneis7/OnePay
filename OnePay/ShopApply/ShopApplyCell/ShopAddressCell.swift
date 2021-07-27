//
//  ShopAddressCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ShopAddressCell: UITableViewCell , UITextViewDelegate{
    
    @IBOutlet weak var inputShopAddressCellTextView: UITextView!
    @IBOutlet weak var shopAddressPlaceholderLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputShopAddressCellTextView.delegate = self
        
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
        inputShopAddressCellTextView.keyboardType = .default
        inputShopAddressCellTextView.autocorrectionType = UITextAutocorrectionType.no
        inputShopAddressCellTextView.spellCheckingType = UITextSpellCheckingType.no
        inputShopAddressCellTextView.returnKeyType = .next
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if (text == "\n") {
            textView.resignFirstResponder()
        } else {
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        subLabel.isHidden = false
        shopAddressPlaceholderLabel.isHidden = true
        Data_Default.shared.IndexPathNum = "keypad"
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = self.inputShopAddressCellTextView?.text
        if text != "" {
            self.subLabel.isHidden = false
            Data_ShopApply.shared.shopApply_Address = text!
        } else {
            self.subLabel.isHidden = true
            shopAddressPlaceholderLabel.isHidden = false
            
        }
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        Data_ShopApply.shared.shopApply_IndexPathNum = "keypad"
        inputShopAddressCellTextView.textColor = .white
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
        inputShopAddressCellTextView.textColor = .white
        return true
    }
}
