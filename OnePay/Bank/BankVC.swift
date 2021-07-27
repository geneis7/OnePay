//
//  BankVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 9..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BankVC: UIViewController {

    @IBOutlet weak var bankTopLabel: UILabel!
    @IBOutlet weak var btn_BankSelect: UIButton!
    
    let serviceUrl = UrlData()
    
    var bankListData:JSON = JSON.init(rawValue: [])!
    var bankList:[String:String] = [:]

    var button = dropDownBtn()
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_BankSelect.layer.cornerRadius = 10
        bankListDataLoad()
        
        
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            //Configure the button
            let buttonTitleColor = UIColor.newColor_Green
            self.button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            self.button.setTitle("         국민은행         ▾", for: .normal)
            self.button.layer.borderWidth = 1
            self.button.layer.borderColor = UIColor.init(red:0/255.0, green:190/255.0, blue:166/255.0, alpha: 1.0).cgColor
            self.button.translatesAutoresizingMaskIntoConstraints = false
            self.button.setTitleColor(buttonTitleColor, for: .normal)
            self.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            
            //Add Button to the View Controller
            self.view.addSubview(self.button)
            
            //button Constraints
            self.button.topAnchor.constraint(equalTo: self.bankTopLabel.bottomAnchor).isActive = true
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.button.widthAnchor.constraint(equalToConstant: 300).isActive = true
            self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true

            //Set the drop down menu's options
            self.button.dropView.dropDownOptions = Data_BankInfo.shared.bankListName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 뒤로 가기 버튼
    @IBAction func backButton(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ElectronicFinanceStoryID")
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    // 결제비밀번호 등록하러 가기 버튼
    @IBAction func goToPaymentPasswordBtn(_ sender: Any) {

        Data_BankInfo.shared.selectBankName = "국민은행"
        Data_BankInfo.shared.selectBankCode = "004"

        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPasswordStoryID")
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    // 은행 리스트 와 코드 정보 불러오기
    func bankListDataLoad(){
        let url = serviceUrl.realServiceUrl + "/onepay/rest/bankList"
        
        let call = Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.bankListData = JSON(value)
                Data_BankInfo.shared.bankListName =  self.bankListData["bankList"].arrayValue.map({$0["bank_name"].stringValue})
                Data_BankInfo.shared.bankListCode =  self.bankListData["bankList"].arrayValue.map({$0["bank_code"].stringValue})

                
                Data_BankInfo.shared.bankListCode = ["004"]
                Data_BankInfo.shared.bankListName = ["국민은행"]
                print("⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️")
                print("\(Data_BankInfo.shared.bankListName)")
                print("\(Data_BankInfo.shared.bankListCode)")
                
                var nameListCnt = 0
                var codeListCnt = 0
                while nameListCnt != Data_BankInfo.shared.bankListName.count {
                     Data_BankInfo.shared.bankSorted_Name[Data_BankInfo.shared.bankListName[codeListCnt]] = Data_BankInfo.shared.bankListCode[nameListCnt]
                    nameListCnt = nameListCnt + 1
                    codeListCnt = codeListCnt + 1
                }
                

            case .failure(let error):
                print(error)
            }
        }
    }
}


protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 270 {
                self.height.constant = 270
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.lightGray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Data_BankInfo.shared.selectBankName = dropDownOptions[indexPath.row]
    
        self.delegate.dropDownPressed(string:"          " + dropDownOptions[indexPath.row] + "         ▾")
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

