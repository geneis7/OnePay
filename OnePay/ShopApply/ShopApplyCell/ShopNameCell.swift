//
//  ShopNameCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ShopNameCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var inputShopNameCellTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        inputShopNameCellTF.delegate = self
        
        cellSetting()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // 기본 셀 셋팅
    func cellSetting(){
        
        subLabel.isHidden = true
        inputShopNameCellTF.becomeFirstResponder()
        inputShopNameCellTF.borderStyle = .none
        inputShopNameCellTF.keyboardType = .default
        inputShopNameCellTF.clearButtonMode = .whileEditing
        inputShopNameCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputShopNameCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputShopNameCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
    }
    @IBAction func inputEnd(_ sender: Any) {
        if inputShopNameCellTF?.text == "" {
            self.subLabel.isHidden = true
            inputShopNameCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    @IBAction func inputStart(_ sender: Any) {
        if inputShopNameCellTF?.text == "" {
            self.subLabel.isHidden = false
            inputShopNameCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputShopNameCellTF.resignFirstResponder()
        return true
    }
    
    @IBAction func strChange(_ sender: Any) {
        let inputText = inputShopNameCellTF?.text
        
        if inputText != ""{
            subLabel.isHidden = false
            inputShopNameCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else if inputText == "" {
            subLabel.isHidden = true
            inputShopNameCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        
        Data_ShopApply.shared.shopApply_Name = inputText!
    }
}





