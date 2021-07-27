//
//  KorNameTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Toaster

// 회원가입 -> 한글 이름 입력 셀
class KorNameTableCell:UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var inputKorNameTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputKorNameTF.attributedPlaceholder = NSAttributedString(string: "한글명",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        cellSetting()
        inputKorNameTF.delegate = self
        inputKorNameTF.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func strChanged(_ sender: Any) {
        let str = inputKorNameTF?.text
        Data_SignUp.shared.signUp_User_Name = str!
    }

    // 알림 메세지 커스텀
    func configureAppearance() {
        let appearance = ToastView.appearance()
        appearance.backgroundColor = .lightGray
        appearance.textColor = .black
        appearance.font = .boldSystemFont(ofSize: 20)
        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        appearance.bottomOffsetPortrait = 100
        appearance.cornerRadius = 20
    }
    
    // 기본 셀 셋팅
    func cellSetting(){
        inputKorNameTF.borderStyle = .none
        inputKorNameTF.keyboardType = .default
        inputKorNameTF.autocorrectionType = UITextAutocorrectionType.no
        inputKorNameTF.spellCheckingType = UITextSpellCheckingType.no
        inputKorNameTF.clearButtonMode = .whileEditing
    }
    
    // 리턴키 눌렀을때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputKorNameTF.resignFirstResponder()
        return true
    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
}


