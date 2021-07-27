//
//  ShopListVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 2. 13..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class ShopListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var shopListTV: UITableView!
    
    var imgUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopListTV.delegate = self
        shopListTV.dataSource = self

        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data_ShopList.shared.shopList_Image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopListCell") as! ShopListCell
        
        self.imgUrl = Data_ShopList.shared.shopList_Image[indexPath.row]
        let url = URL(string: self.imgUrl)
        let data = try? Data(contentsOf: url!)
        let imageData = data
        
        
        cell.shopListCell_ShopImage.image = UIImage(data: imageData!)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewStoryID")
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
//        if let url = URL(string: Data_ShopList.shared.shopList_Url[indexPath.row]) {
//            UIApplication.shared.open(url, options: [:])
//        }
    }
    

    
}
