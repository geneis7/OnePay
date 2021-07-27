//
//  ShopAccountNumCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import KBNumberPad
import CryptoSwift

class ShopAccountNumCell: UITableViewCell,UITextFieldDelegate,KBNumberPadDelegate {

    @IBOutlet weak var inputShopAccountNumCellTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    
    var accNum:String = ""
    var accountNum:String = ""
    var encryptData:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputShopAccountNumCellTF.delegate = self
        cellSetting()
        numberPadSetting()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inputEnd(_ sender: Any) {
        if inputShopAccountNumCellTF?.text == "" {
            self.subLabel.isHidden = true
            inputShopAccountNumCellTF.attributedPlaceholder = NSAttributedString(string: "숫자만 입력(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
    }
    
    @IBAction func inputStart(_ sender: Any) {
        if inputShopAccountNumCellTF?.text == "" {
            self.subLabel.isHidden = false
            inputShopAccountNumCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        Data_ShopApply.shared.shopApply_IndexPathNum = ""
    }
    
    
    // 기본 셀 셋팅
    func cellSetting(){
        subLabel.isHidden = true
        inputShopAccountNumCellTF.borderStyle = .none
        inputShopAccountNumCellTF.clearButtonMode = .whileEditing
        inputShopAccountNumCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputShopAccountNumCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputShopAccountNumCellTF.attributedPlaceholder = NSAttributedString(string: "숫자만 입력(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputShopAccountNumCellTF.resignFirstResponder()
        return true
    }
    
    func numberPadSetting(){
        let numberPad = KBNumberPad()
        let str = "clear"
        
        inputShopAccountNumCellTF.inputView = numberPad
        
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
        accNum = accNum + "\(number)"
        inputShopAccountNumCellTF.text = accNum
        
        let inputText = inputShopAccountNumCellTF?.text
        
        if inputText != ""{
            subLabel.isHidden = false
            inputShopAccountNumCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else if inputText == "" {
            subLabel.isHidden = true
            inputShopAccountNumCellTF.attributedPlaceholder = NSAttributedString(string: "숫자만 입력(-제외)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        
        self.realAccountNumEncrypted()
        let encData = encryptData

        Data_ShopApply.shared.shopApply_AccountNumber = encData
    }
    
    func onDoneClicked(numberPad: KBNumberPad) {
        inputShopAccountNumCellTF.resignFirstResponder()
    }
    
    func onClearClicked(numberPad: KBNumberPad) {
        let str_drop_last = accNum.dropLast()
        accNum = String(str_drop_last)
        inputShopAccountNumCellTF.text = accNum
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        accNum = ""
        inputShopAccountNumCellTF?.text = ""
        return true
    }

    func realAccountNumEncrypted() {
        do {
            encryptData = try aesEncrypt(key: "okpay123okpay123okpay123okpay123", iv: "")
        } catch {
            print(error)
        }
    }
    
    func aesEncrypt(key: String, iv: String) throws -> String {
        let accountNum = inputShopAccountNumCellTF?.text
        let data = accountNum!.data(using: .utf8)!
        let encrypted = try! AES(key: key.bytes, blockMode: .ECB, padding: .pkcs5).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
}
