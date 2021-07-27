//
//  SmartCon_BrandVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 4. 5..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit


class SmartCon_BrandVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    @IBOutlet weak var brandVC_BrandImage: UIImageView!
    @IBOutlet weak var brandVC_BrandName: UILabel!
    @IBOutlet weak var brandVC_BrandCatePath: UILabel!
    @IBOutlet weak var smartCon_BrandTV: UITableView!
    @IBOutlet weak var smartCon_BrandView: UIView!
    
    
    var selectGoodsInfo:[String] = []
    
    var smartCon_Brand_disc_price:[String] = []
    var smartCon_Brand_disc_rate:[String] = []
    var smartCon_Brand_goods_id:[String] = []
    var smartCon_Brand_goods_name:[String] = []
    var smartCon_Brand_img_url:[String] = []
    var smartCon_Brand_msg:[String] = []
    var smartCon_Brand_price:[String] = []
    var smartCon_Brand_cancelable:[String] = []
    
    var selectBrandArray = [String] ()
    var imgUrl:String = ""
    var imgUrl2:String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        smartCon_BrandView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)

        selectBrandArray = Data_SmartCon.shared.smartCon_SelectBrandData
        
        smartCon_Brand_disc_price = Data_SmartCon_Goods.shared.smartCon_Goods_disc_price
        smartCon_Brand_disc_rate = Data_SmartCon_Goods.shared.smartCon_Goods_disc_rate
        smartCon_Brand_goods_id = Data_SmartCon_Goods.shared.smartCon_Goods_goods_id
        smartCon_Brand_goods_name = Data_SmartCon_Goods.shared.smartCon_Goods_goods_name
        smartCon_Brand_img_url = Data_SmartCon_Goods.shared.smartCon_Goods_img_url
        smartCon_Brand_msg = Data_SmartCon_Goods.shared.smartCon_Goods_msg
        smartCon_Brand_price = Data_SmartCon_Goods.shared.smartCon_Goods_price
        smartCon_Brand_cancelable = Data_SmartCon_Goods.shared.smartCon_Goods_cancelable
        

        defaultSetting()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func defaultSetting() {
        smartCon_BrandTV.delegate = self
        smartCon_BrandTV.dataSource = self

        brandVC_BrandName.text? = selectBrandArray[0]
        brandVC_BrandCatePath.text? = selectBrandArray[1] + " > " + selectBrandArray[0]
        
        self.imgUrl = self.selectBrandArray[3]
        let url = URL(string: self.imgUrl)
        let data = try? Data(contentsOf: url!)
        let imageData = data

        brandVC_BrandImage.image = UIImage(data: imageData!)

    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smartCon_Brand_goods_id.count
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_BrandCell", for: indexPath) as? SmartCon_BrandCell
        

        cell?.brandCell_BrandName.text? = selectBrandArray[0]
        cell?.brandCell_BrandDetail.text? = smartCon_Brand_goods_name[indexPath.row]
        cell?.brandCell_MenuPrice.text? = String(describing: Int(smartCon_Brand_price[indexPath.row])!.withComma) + " P"
        
        imgUrl2 = smartCon_Brand_img_url[indexPath.row]
        let url = URL(string: imgUrl2)
        let data = try? Data(contentsOf: url!)
        let imageData = data
        
        
        cell?.brandCell_MenuImage.image = UIImage(data: imageData!)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectCell = indexPath.row

            selectGoodsInfo.append(selectBrandArray[0])
            selectGoodsInfo.append(smartCon_Brand_goods_id[selectCell])
            selectGoodsInfo.append(smartCon_Brand_goods_name[selectCell])
            selectGoodsInfo.append(smartCon_Brand_img_url[selectCell])
            selectGoodsInfo.append(smartCon_Brand_msg[selectCell])
            selectGoodsInfo.append(smartCon_Brand_price[selectCell])
            selectGoodsInfo.append(smartCon_Brand_cancelable[selectCell])
            selectGoodsInfo.append(smartCon_Brand_disc_price[selectCell])
            selectGoodsInfo.append(smartCon_Brand_disc_rate[selectCell])
        
            Data_SmartCon.shared.smartCon_SelectGoodsInfo = self.selectGoodsInfo
            
            selectGoodsInfo.removeAll()

                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SmartCon_Brand_DetailStoryID")
                
                self.navigationController?.pushViewController(nextVC!, animated: true)

    }
    
    
}
