//
//  ShopPhoneNumCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import KBNumberPad

class ShopPhoneNumCell: UITableViewCell,UITextFieldDelegate,KBNumberPadDelegate {

    @IBOutlet weak var inputShopPhoneNumCellTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    var phoneNum:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputShopPhoneNumCellTF.delegate = self
        cellSetting()
        numberPadSetting()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inputEnd(_ sender: Any) {
        if inputShopPhoneNumCellTF?.text == "" {
            self.subLabel.isHidden = true
            inputShopPhoneNumCellTF.attributedPlaceholder = NSAttributedString(string: "010 포함(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
    }
    
    @IBAction func inputStart(_ sender: Any) {
        if inputShopPhoneNumCellTF?.text == "" {
            self.subLabel.isHidden = false
            inputShopPhoneNumCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_IndexPathNum = "numpad"
    }
    
    
    // 기본 셀 셋팅
    func cellSetting(){
        subLabel.isHidden = true
        inputShopPhoneNumCellTF.borderStyle = .none
        inputShopPhoneNumCellTF.keyboardType = .default
        inputShopPhoneNumCellTF.clearButtonMode = .whileEditing
        inputShopPhoneNumCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputShopPhoneNumCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputShopPhoneNumCellTF.attributedPlaceholder = NSAttributedString(string: "010 포함(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputShopPhoneNumCellTF.resignFirstResponder()
        return true
    }
    
    
    func numberPadSetting(){
        let numberPad = KBNumberPad()
        let str = "clear"
        
        inputShopPhoneNumCellTF.inputView = numberPad
        
        numberPad.setDelimiterColor(UIColor.lightGray)
        numberPad.setButtonsColor(UIColor.darkGray)
        numberPad.setButtonsBackgroundColor(UIColor.white)
        
        numberPad.setNumberButtonsColor(UIColor.black)
        numberPad.setClearButtonColor(UIColor.darkGray)
        numberPad.setDoneButtonColor(UIColor.darkGray)
        numberPad.setClearButtonImage(#imageLiteral(resourceName: "asterisk"))
        numberPad.setDoneButtonTitle(str)
        
        numberPad.delegate = self
    }
    
    func onNumberClicked(numberPad: KBNumberPad, number: Int) {
        phoneNum = phoneNum + "\(number)"
        inputShopPhoneNumCellTF.text = phoneNum
        
        let inputText = inputShopPhoneNumCellTF?.text
        
        if inputText != ""{
            subLabel.isHidden = false
            inputShopPhoneNumCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else if inputText == "" {
            subLabel.isHidden = true
            inputShopPhoneNumCellTF.attributedPlaceholder = NSAttributedString(string: "010 포함(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        
        Data_ShopApply.shared.shopApply_PhoneNumber = inputText!
    }
    
    func onDoneClicked(numberPad: KBNumberPad) {
        inputShopPhoneNumCellTF.resignFirstResponder()
    }
    
    func onClearClicked(numberPad: KBNumberPad) {
        let str_drop_last = phoneNum.dropLast()
        phoneNum = String(str_drop_last)
        inputShopPhoneNumCellTF.text = phoneNum
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        phoneNum = ""
        inputShopPhoneNumCellTF?.text = ""
        return true
    }

}
