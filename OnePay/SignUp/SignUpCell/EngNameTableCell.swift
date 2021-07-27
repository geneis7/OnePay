//
//  EngNameTableCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import Foundation
import UIKit
import Toaster

// 회원가입 -> 영어 이름 입력 셀
class EngNameTableCell:UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var inputEngNameTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputEngNameTF.attributedPlaceholder = NSAttributedString(string: "영문명",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        cellSetting()
        inputEngNameTF.delegate = self
        inputEngNameTF.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editEnd(_ sender: Any) {
        Data_Default.shared.IndexPathNum = ""
    }
    
    @IBAction func inputEngNameTableCellTF_Touched(_ sender: Any) {
        let str = inputEngNameTF?.text
        Data_SignUp.shared.signUp_User_EngName = str!
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
        inputEngNameTF.borderStyle = .none
        inputEngNameTF.keyboardType = .alphabet
        inputEngNameTF.autocorrectionType = UITextAutocorrectionType.no
        inputEngNameTF.spellCheckingType = UITextSpellCheckingType.no
        inputEngNameTF.clearButtonMode = .whileEditing
        
    }
    
    // 리턴키 눌렀을때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputEngNameTF.resignFirstResponder()
        return true
    }
}
