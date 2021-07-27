//
//  ShopAccoutHolderCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 12..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import CryptoSwift

class ShopAccoutHolderCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var inputShopAccoutHolderCellTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    var encryptData:String = ""
    var accountHolderName:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputShopAccoutHolderCellTF.delegate = self
        cellSetting()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inputEnd(_ sender: Any) {
        if inputShopAccoutHolderCellTF?.text == "" {
            self.subLabel.isHidden = true
            inputShopAccoutHolderCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    @IBAction func inputStart(_ sender: Any) {
        if inputShopAccoutHolderCellTF?.text == "" {
            self.subLabel.isHidden = false
            inputShopAccoutHolderCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    
    // 기본 셀 셋팅
    func cellSetting(){
        subLabel.isHidden = true
        inputShopAccoutHolderCellTF.borderStyle = .none
        inputShopAccoutHolderCellTF.keyboardType = .default
        inputShopAccoutHolderCellTF.clearButtonMode = .whileEditing
        inputShopAccoutHolderCellTF.autocorrectionType = UITextAutocorrectionType.no
        inputShopAccoutHolderCellTF.spellCheckingType = UITextSpellCheckingType.no
        inputShopAccoutHolderCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputShopAccoutHolderCellTF.resignFirstResponder()
        return true
    }

    @IBAction func strChange(_ sender: Any) {
        let inputText = inputShopAccoutHolderCellTF?.text
        
        if inputText != ""{
            subLabel.isHidden = false
            inputShopAccoutHolderCellTF.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else if inputText == "" {
            subLabel.isHidden = true
            inputShopAccoutHolderCellTF.attributedPlaceholder = NSAttributedString(string: "(ex)원페이)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        self.realAccountHolderEncrypted()
        let encData = encryptData
        Data_ShopApply.shared.shopApply_AccountHolder = encData
    }
    
    func realAccountHolderEncrypted() {
        do {
            encryptData = try aesEncrypt(key: "okpay123okpay123okpay123okpay123", iv: "")
        } catch {
            print(error)
        }
    }
    
    func aesEncrypt(key: String, iv: String) throws -> String {
        let accountHolderName = inputShopAccoutHolderCellTF?.text
        let data = accountHolderName!.data(using: .utf8)!
        let encrypted = try! AES(key: key.bytes, blockMode: .ECB, padding: .pkcs5).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
}
