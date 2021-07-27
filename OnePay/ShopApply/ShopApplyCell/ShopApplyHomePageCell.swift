//
//  ShopApplyHomePageCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 3. 13..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ShopApplyHomePageCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var inputShopHomepageCellTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputShopHomepageCellTF.delegate = self
        cellSetting()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func inputEnd(_ sender: Any) {
        if inputShopHomepageCellTF?.text == "" {
            self.subLabel.isHidden = true
            
        }
    }
    
    @IBAction func inputStart(_ sender: Any) {
        if inputShopHomepageCellTF?.text == "" {
            self.subLabel.isHidden = false
            inputShopHomepageCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    
    // 기본 셀 셋팅
    func cellSetting(){
        subLabel.isHidden = true
        inputShopHomepageCellTF.borderStyle = .none
        inputShopHomepageCellTF.keyboardType = .URL
        inputShopHomepageCellTF.clearButtonMode = .whileEditing
        inputShopHomepageCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputShopHomepageCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputShopHomepageCellTF.attributedPlaceholder = NSAttributedString(string: "온라인샵 신청시 입력",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputShopHomepageCellTF.resignFirstResponder()
        return true
    }
    
    @IBAction func strChange(_ sender: Any) {
        let inputText = inputShopHomepageCellTF?.text
        Data_ShopApply.shared.shopApply_IndexPathNum = "up"
        if inputText != ""{
            subLabel.isHidden = false
            inputShopHomepageCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else if inputText == "" {
            subLabel.isHidden = true
            inputShopHomepageCellTF.attributedPlaceholder = NSAttributedString(string: "온라인샵 신청시 입력",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_HomePage = inputText!
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        Data_ShopApply.shared.shopApply_IndexPathNum = "keypad"
        if inputShopHomepageCellTF.text == "" {
            inputShopHomepageCellTF.attributedPlaceholder = NSAttributedString(string: "온라인샵 신청시 입력",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        return true
    }
    
    @IBAction func editEnd(_ sender: Any) {
        if inputShopHomepageCellTF.text == "" {
            inputShopHomepageCellTF.attributedPlaceholder = NSAttributedString(string: "온라인샵 신청시 입력",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
    }
}

