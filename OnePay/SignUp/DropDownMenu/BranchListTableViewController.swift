//
//  ListViewController.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 15..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class BranchListTableViewController: UITableViewController {
    
    var delegate: SignUpVC?
    var branchNameList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.branchNameList =  Data_SignUp.shared.signUp_branch_Name
        
        self.preferredContentSize.height = 220
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return branchNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = branchNameList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        Data_SignUp.shared.signUp_Select_Branch_Name = branchNameList[indexPath.row]
        
        Data_SignUp.shared.signUp_Select_Branch_Code = Data_SignUp.shared.signUp_branch_List[Data_SignUp.shared.signUp_Select_Branch_Name]!
        
        print("//---------->    지점선택 결과  <----------//")
        print("선택된 지점는 \(branchNameList[indexPath.row])입니다.")
        
    }
}

