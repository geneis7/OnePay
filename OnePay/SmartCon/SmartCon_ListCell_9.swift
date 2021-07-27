//
//  SmartCon_ListCell_9.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 4. 3..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

protocol SmartCon_ListCell_9_Protocol {
    func smartCon_ListCell_9_Protocol(SmartCon_ListCell_9_Protocol: SmartCon_ListCell_9)
    func sendData(data: Array<Any>)

}


class SmartCon_ListCell_9: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var smartConList_CollCell: UICollectionView!
    @IBOutlet weak var smartCon_CollView: UICollectionView!
    
    @IBOutlet weak var headerView_1: UIView!
    @IBOutlet weak var headerView_Image: UIImageView!
    @IBOutlet weak var headerView_Label: UILabel!
    @IBOutlet weak var headerView_Btn: UIImageView!
    
    var cateIconImageArray = [String] ()
    var cateNameArray = [String] ()
    var imgUrl2:String = ""
    var expandebleCheck:Bool = true
    var delegate:SmartCon_ListCell_9_Protocol?
    
    
    var cateBrandImageArray = [String] ()
    var viewWith:String = ""
    var imgUrl:String = ""
    
    //추가
    var cnt = 0
    var selectCheck = true
    var cateBrandCodeArray = [String] ()
    var sendBrandDataArray = [String] ()
    var cateBrandNameArray = [String] ()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.smartConList_CollCell.delegate = self
        self.smartConList_CollCell.dataSource = self
        
        Data_SmartCon.shared.smartCon_SelectBrandImageIndex = ""
        
        cateBrandCodeArray = Data_SmartCon.shared.smartCon_brand_code_array["SmartCon_brand_code_10"]!
        cateBrandImageArray = Data_SmartCon.shared.smartCon_brand_img_array["SmartCon_brand_img_10"]!
        cateBrandNameArray = Data_SmartCon.shared.smartCon_brand_name_array["SmartCon_brand_name_10"]!
        
        cateIconImageArray = Data_SmartCon.shared.smartCon_icon_url
        cateNameArray = Data_SmartCon.shared.smartCon_cate_name
        
        
        // 화면 터치 이벤트
        headerView_1.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        headerView_1.addGestureRecognizer(tapRecognizer)
        
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.imgUrl2 = self.cateIconImageArray[9]
            let url = URL(string: self.imgUrl2)
            let data = try? Data(contentsOf: url!)
            let imageData = data
            self.headerView_Image.image = UIImage(data: imageData!)
            self.headerView_Label?.text = self.cateNameArray[9]
            self.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
        }
        
        
    }
    
    @objc func imageViewTapped(imageView:UITapGestureRecognizer? = nil ) {
        
        if expandebleCheck == true {
            self.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
            expandebleCheck = false
        } else {
            self.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
            expandebleCheck = true
        }
        self.delegate?.smartCon_ListCell_9_Protocol(SmartCon_ListCell_9_Protocol: self)
        
        print("이미지 탭!!!!!!!!!!!!!!!")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectBrandImageIndex = String(indexPath.row)
        
        sendBrandDataArray.append(self.cateBrandNameArray[indexPath.row])
        sendBrandDataArray.append(self.cateNameArray[9])
        sendBrandDataArray.append(self.cateBrandCodeArray[indexPath.row])
        sendBrandDataArray.append(self.cateBrandImageArray[indexPath.row])
        
        
        
        Data_SmartCon.shared.smartCon_SelectBrandData = self.sendBrandDataArray
        
        self.delegate?.sendData(data: sendBrandDataArray)
        
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            
            if self.selectCheck == true {
                self.sendBrandDataArray.removeAll()
                Data_SmartCon.shared.smartCon_SelectBrandImageIndex = selectBrandImageIndex
                self.delegate?.smartCon_ListCell_9_Protocol(SmartCon_ListCell_9_Protocol: self)
            }
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cateBrandImageArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: SmartConList_CollectionCell_9 = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartConList_CollectionCell_9", for: indexPath) as? SmartConList_CollectionCell_9
        {
            
            imgUrl = cateBrandImageArray[indexPath.row]
            let url = URL(string: imgUrl)
            let data = try? Data(contentsOf: url!)
            let imageData = data
            
            cell.smartConList_CollCellImage.image = UIImage(data: imageData!)
            cell.smartConList_Brand_Name_Label?.text = self.cateBrandNameArray[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let viewWith = Data_Default.shared.device_WidthSize
        let imageWidth = Double(viewWith)! / Double(3.33)
        let size = CGSize(width: imageWidth , height: imageWidth + 10)
        return size
    }
    
    
    
}

