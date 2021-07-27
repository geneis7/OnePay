//
//  ShopBusinessNumCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import KBNumberPad
import CryptoSwift

class ShopBusinessNumCell: UITableViewCell ,UITextFieldDelegate, KBNumberPadDelegate{

    @IBOutlet weak var inputShopBusinessNumCellTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    var businessNum:String = ""
    var encryptData:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        inputShopBusinessNumCellTF.delegate = self
        cellSetting()
        numberPadSetting()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inputEnd(_ sender: Any) {
        if inputShopBusinessNumCellTF?.text == "" {
            self.subLabel.isHidden = true
            inputShopBusinessNumCellTF.attributedPlaceholder = NSAttributedString(string: "숫자만 입력(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
        
    }
    
    @IBAction func inputStart(_ sender: Any) {
        if inputShopBusinessNumCellTF?.text == "" {
            self.subLabel.isHidden = false
            inputShopBusinessNumCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
    }
    
    
    
    // 기본 셀 셋팅
    func cellSetting(){
        subLabel.isHidden = true
        inputShopBusinessNumCellTF.borderStyle = .none
//        inputShopBusinessNumCellTF.keyboardType = .default
        inputShopBusinessNumCellTF.clearButtonMode = .whileEditing
        inputShopBusinessNumCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputShopBusinessNumCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputShopBusinessNumCellTF.attributedPlaceholder = NSAttributedString(string: "숫자만 입력(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputShopBusinessNumCellTF.resignFirstResponder()
        return true
    }

    func numberPadSetting(){
        let numberPad = KBNumberPad()
        let str = "clear"
        
        inputShopBusinessNumCellTF.inputView = numberPad
        
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
        businessNum = businessNum + "\(number)"
        inputShopBusinessNumCellTF.text = businessNum
        
        let inputText = inputShopBusinessNumCellTF?.text
        
        if inputText != ""{
            subLabel.isHidden = false
            inputShopBusinessNumCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else if inputText == "" {
            subLabel.isHidden = true
            inputShopBusinessNumCellTF.attributedPlaceholder = NSAttributedString(string: "숫자만 입력(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        self.realBusinessNumEncrypted()
        let encData = encryptData

        Data_ShopApply.shared.shopApply_BusinessNum = encData
        
    }
    
    func onDoneClicked(numberPad: KBNumberPad) {
        inputShopBusinessNumCellTF.resignFirstResponder()
    }
    
    func onClearClicked(numberPad: KBNumberPad) {
        let str_drop_last = businessNum.dropLast()
        businessNum = String(str_drop_last)
        inputShopBusinessNumCellTF.text = businessNum
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        businessNum = ""
        inputShopBusinessNumCellTF?.text = ""
        return true
    }
    
    
    func realBusinessNumEncrypted() {
        do {
            encryptData = try aesEncrypt(key: "okpay123okpay123okpay123okpay123", iv: "")
        } catch {
            print(error)
        }
    }
    
    func aesEncrypt(key: String, iv: String) throws -> String {
        let businessNum = inputShopBusinessNumCellTF?.text
        let data = businessNum!.data(using: .utf8)!
        let encrypted = try! AES(key: key.bytes, blockMode: .ECB, padding: .pkcs5).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }

}
