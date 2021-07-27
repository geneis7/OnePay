//
//  CountryListTableViewController.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 27..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit



class CountryListTableViewController: UITableViewController {
    
    let countryNameList = CountryList.countryList.keys
    var delegate: SignUpVC?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize.height = 300
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CountryList.countryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let countryNameArray = Array(countryNameList).sorted()
        cell.textLabel!.text = countryNameArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let countryNameArray = Array(countryNameList).sorted()
        let selectCountryName = countryNameArray[indexPath.row]
        
        let selectCountryCode = CountryList.countryList["\(selectCountryName)"]!
        
        Data_SignUp.shared.signUp_User_Nation_Name = selectCountryName
        Data_SignUp.shared.signUp_User_Nation_Code = selectCountryCode

        
        print("//---------->    국가선택 결과  <----------//")
        print("선택된 국가는 \(countryNameArray[indexPath.row])입니다.")
        print("선택된 국가코드는 \(String(describing: selectCountryCode))입니다.")
    }
    
}
