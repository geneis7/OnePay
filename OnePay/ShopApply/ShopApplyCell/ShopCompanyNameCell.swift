//
//  ShopCompanyNameCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ShopCompanyNameCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var inputShopCompanyNameCellTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputShopCompanyNameCellTF.delegate = self
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
        inputShopCompanyNameCellTF.borderStyle = .none
        inputShopCompanyNameCellTF.keyboardType = .default
        inputShopCompanyNameCellTF.clearButtonMode = .whileEditing
        inputShopCompanyNameCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputShopCompanyNameCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputShopCompanyNameCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputShopCompanyNameCellTF.resignFirstResponder()
        return true
    }
    
    @IBAction func inputEnd(_ sender: Any) {
        if inputShopCompanyNameCellTF?.text == "" {

            self.subLabel.isHidden = true
            inputShopCompanyNameCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    @IBAction func inputStart(_ sender: Any) {
        if inputShopCompanyNameCellTF?.text == "" {
            self.subLabel.isHidden = false
            inputShopCompanyNameCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
        
        
        
    @IBAction func strChange(_ sender: Any) {
        let inputText = inputShopCompanyNameCellTF?.text
        
        if inputText != ""{
            subLabel.isHidden = false
            inputShopCompanyNameCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else if inputText == "" {
            subLabel.isHidden = true
            inputShopCompanyNameCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_Company_Name = inputText!
    }
}
