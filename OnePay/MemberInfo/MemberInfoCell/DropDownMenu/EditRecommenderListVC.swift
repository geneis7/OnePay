//
//  EditRecommenderListVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 3. 7..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class EditRecommenderListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var editRecommenderListTV: UITableView!
    let serviceUrl = UrlData()
    
    var recommenderListData:JSON = JSON.init(rawValue: [])!
    var recommenderList:[String:String] = [:]
    var recommenderId:[String] = []
    var recommenderName:[String] = []
    var recommenderDate:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editRecommenderListTV.delegate = self
        recommenderListDataLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommenderId.count
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditRecommenderListCell") as! EditRecommenderListCell
        
        cell.editRecommenderListCell_Id_TF?.text = recommenderId[indexPath.row]
        cell.editRecommenderListCell_Name_TF?.text = recommenderName[indexPath.row]
        if recommenderName.count < 1 {
            cell.editRecommenderListCell_Name_TF?.text = "추천회원이 없습니다."
        }
        cell.editRecommenderListCell_Date_TF?.text = recommenderDate[indexPath.row]
        
        return cell
    }
    
    func recommenderListDataLoad(){
        
        let member_srls = Data_MemberInfo.shared.member_srl
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/memberInfo"
            let param: Parameters = [
                "member_srl": member_srls
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                case .success(let value):
                    print("리커맨더 체크 3")
                    self.recommenderListData = JSON(value)
                    print(self.recommenderListData)
                    self.recommenderId =  self.recommenderListData["recommenderList"].arrayValue.map({$0["user_id"].stringValue})
                    self.recommenderName =  self.recommenderListData["recommenderList"].arrayValue.map({$0["user_name"].stringValue})
                    self.recommenderDate =  self.recommenderListData["recommenderList"].arrayValue.map({$0["recommendDate"].stringValue})
                    
                    print(self.recommenderId)
                    print(self.recommenderName)
                    print(self.recommenderDate)
                    
                    
                    DispatchQueue.main.async {
                        self.editRecommenderListTV.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
