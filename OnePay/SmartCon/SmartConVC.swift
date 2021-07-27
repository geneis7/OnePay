//
//  SmartConVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 3. 21..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SmartConVCProtocol {
    func smartConVCProtocol(smartConVCProtocol:SmartConVC)
}

class SmartConVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SmartCon_ListCell_0_Protocol,SmartCon_ListCell_1_Protocol,SmartCon_ListCell_2_Protocol,SmartCon_ListCell_3_Protocol,SmartCon_ListCell_4_Protocol,SmartCon_ListCell_5_Protocol,SmartCon_ListCell_6_Protocol,SmartCon_ListCell_7_Protocol,SmartCon_ListCell_8_Protocol,SmartCon_ListCell_9_Protocol{

    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var smartCon_ListTV: UITableView!
    @IBOutlet weak var smartCon_MyConTV: UITableView!
    @IBOutlet weak var smartCon_ListCollView: UICollectionView!
    @IBOutlet weak var smartCon_Activity: UIActivityIndicatorView!
    
    
    @IBOutlet weak var couponListOutlet: UIButton!
    @IBOutlet weak var myCouponOutlet: UIButton!
    @IBOutlet weak var couponListBtnSelectImage: UIImageView!
    @IBOutlet weak var myCouponSelectImage: UIImageView!
    @IBOutlet weak var smartCon_BannerImage: UIImageView!
    @IBOutlet weak var smartCon_BannerImage_Logo: UIImageView!
    @IBOutlet weak var smartConTopView: UIView!
    @IBOutlet weak var smartConBtnView: UIView!
    @IBOutlet weak var smartConslideMenuBtnOutlet: UIButton!
    
    // 브랜드 리스트 이동 관련
    var selectBrand_ListData:JSON = JSON.init(rawValue: [])!
    var selectBrand_Goods_Array:[String] = []
    var smartCon_Brand_disc_price = [String] ()
    var smartCon_Brand_disc_rate = [String] ()
    var smartCon_Brand_goods_id = [String] ()
    var smartCon_Brand_goods_name = [String] ()
    var smartCon_Brand_img_url = [String] ()
    var smartCon_Brand_msg = [String] ()
    var smartCon_Brand_price = [String] ()
    var smartCon_Brand_cancelable = [String] ()
    
    var cellSelectCheckCnt = 1

    let serviceUrl = UrlData()
    
    var cellHeight:Int = 0
    var cellSection:Int = 0
    var cellExpandebleCheck:Bool = false
    
    // we set a variable to hold the contentOffSet before scroll view scrolls
    var lastContentOffset: CGFloat = 0
    
    var tableIndex:Int = 0
    
    var highLowCheck:Bool = false
    
    var bannerViewWidth:CGFloat?
    var bannerViewHeight:CGFloat?
    var topViewHeight:CGFloat?
    var statusBarHeight:CGFloat?
    var tableviewHeight:CGFloat?
    
    var scrollUpDwonCheck:Bool?
    var scrollImageName:String = "giftshop_list_arrow01"
    var selectHeaderIndexNum:Int = 0
    
    let reuseIdentifier:String = "myCell"
    var indexHeaderImageName2 = 1
    
    // 스마트콘 - 실시간 교환상태 영역
    var myConList_ValiData:JSON = JSON.init(rawValue: [])!
    var myCon_Vali_claim_type:[String] = []
    var myCon_Vali_valid_start:[String] = []
    var myCon_Vali_valid_end:[String] = []
    var myCon_Vali_tr_id:[String] = []
    var myCon_Vali_exchange_date:[String] = []
    var myCon_Vali_order_date:[String] = []
    var myCon_Vali_exchange_status:[String] = []
    var myCon_Vali_cancel_period:[String] = []
    var myCon_Vali_cancelable:[String] = []
    var myCon_Vali_Detail_Data:[String] = []
    var myCon_Vali_loop_cnt:Int = 0
    var myCon_Vali_loop_cnt2:Int = 0
    var myCon_Vali_Data_Load_Status:Bool = true
    var cnt = 0
    
    // 스마트콘 - 나의쿠폰 영역
    var myConListData:JSON = JSON.init(rawValue: [])!
    var myCon_tr_id:[String] = []
    var myCon_tr_id_add:[String] = []
    var myCon_member_srl:[String] = []
    var myCon_event_id:[String] = []
    var myCon_goods_id:[String] = []
    var myCon_disc_price:[String] = []
    var myCon_disc_rate:[String] = []
    var myCon_price:[String] = []
    var myCon_order_cnt:[String] = []
    var myCon_img_url:[String] = []
    var myCon_exchange_status:[String] = []
    var myCon_goods_name:[String] = []
    var myCon_brand_name:[String] = []
    var myCon_start_num_add:Int = 5
    var myCon_total_cnt:String = ""
    

    var firstLoadCheck:Bool = true
    
    var titleName:String = ""
    var subTitleName:String = ""
    var brandName:String = ""
    var exchange:String = ""
    var price:String = ""
    var brandNameCount:Int = 0
    var brandImgUrl:String = ""
    var cateIconImgUrl:String = ""
    var cateNameListArray:[String] = []
    var cateIconImageListArray:[String] =  []
    var smartCon_brand_Array_Cnt:[String] =  []
    
    var testCnt = 0
    var arr:[Int] = []
    var imageRollUpCheck2:Bool = true
    var imageCollSpanCheck:Bool = true
    var listCellExpandCheck:Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(smartCon_Activity)
        
        self.smartCon_Activity.frame.size.width = 80
        self.smartCon_Activity.frame.size.height = 80

        self.smartCon_Activity.isHidden = true
        self.smartCon_Activity.assignColor(.black)

        
        couponListOutlet.isEnabled = false
        myCouponOutlet.isEnabled = true
        
        smartCon_ListTV.isUserInteractionEnabled = true
        smartCon_MyConTV.isUserInteractionEnabled = false

        
        
        
        myCon_Vali_claim_type = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_claim_type
        myCon_Vali_valid_start = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_valid_start
        myCon_Vali_valid_end = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_valid_end
        myCon_Vali_tr_id = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_tr_id
        myCon_Vali_exchange_date = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_exchange_date
        myCon_Vali_order_date = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_order_date
        myCon_Vali_exchange_status = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_exchange_status
        myCon_Vali_cancel_period = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_cancel_period
        myCon_Vali_cancelable = Data_SmartCon_MyCon_Vali.shared.myCon_Vali_cancelable
        
        myCon_total_cnt = Data_SmartCon_MyCon.shared.myCon_total_cnt
        myCon_img_url = Data_SmartCon_MyCon.shared.myCon_img_url_array
        myCon_goods_name = Data_SmartCon_MyCon.shared.myCon_goods_name_array
        myCon_brand_name = Data_SmartCon_MyCon.shared.myCon_brand_name_array
        myCon_price = Data_SmartCon_MyCon.shared.myCon_price_array
        myCon_exchange_status = Data_SmartCon_MyCon.shared.myCon_exchange_status_array
        
        cateNameListArray = Data_SmartCon.shared.smartCon_cate_name
        smartCon_brand_Array_Cnt = Data_SmartCon.shared.smartCon_brand_Total_Array
        cateIconImageListArray = Data_SmartCon.shared.smartCon_icon_url


        self.smartCon_MyConTV.isHidden = true
        self.bannerViewWidth = self.smartCon_BannerImage.frame.width
        self.bannerViewHeight = self.smartCon_BannerImage.frame.height
        self.topViewHeight = self.smartConTopView.frame.height
        self.statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableviewHeight = self.smartCon_ListTV.frame.size.height
        
        self.smartCon_MyConTV.isHidden = true
        
        self.defaultSetting()
        
        let HEADER_HEIGHT = 100
        self.smartCon_ListTV.tableHeaderView?.frame.size = CGSize(width: self.smartCon_ListTV.frame.width, height: CGFloat(HEADER_HEIGHT))
        self.smartCon_ListTV.backgroundColor = UIColor.white
        self.smartCon_MyConTV.backgroundColor = UIColor.white
        
        
        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            
            self.smartConslideMenuBtnOutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
            //                        self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
            self.view.addGestureRecognizer(revealVC.tapGestureRecognizer())
        }
        
        smartCon_ListTV.reloadData()
        
    }

    // 스마트콘 리스트 테이블뷰 선택 버튼
    @IBAction func couponListBtn(_ sender: Any) {
        
        smartCon_ListTV.isUserInteractionEnabled = true
        smartCon_MyConTV.isUserInteractionEnabled = false
        
        self.smartCon_ListTV.isHidden = false
        self.smartCon_MyConTV.isHidden = true
        
        // 버튼 선택시 배경 색 변경
        myCouponOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        myCouponSelectImage.backgroundColor = UIColor.white
        couponListOutlet.setTitleColor(UIColor.newColor_Cranberry, for: .normal)
        couponListBtnSelectImage.backgroundColor = UIColor.newColor_Cranberry
        
        
        couponListOutlet.isEnabled = false
        myCouponOutlet.isEnabled = true
        smartCon_ListTV.reloadData()

        
    }
    
    // 나의 쿠폰 테이블뷰 선택 버튼
    @IBAction func myCouponBtn(_ sender: Any) {
        smartCon_ListTV.isUserInteractionEnabled = false
        smartCon_MyConTV.isUserInteractionEnabled = true
        
        if listCellExpandCheck == true {
            self.imageRollUpCheck2 = false
        } else {
            self.imageRollUpCheck2 = true
        }
        
        
        self.smartCon_ListTV.isHidden = true
        self.smartCon_MyConTV.isHidden = false
        
        // 버튼 선택시 배경 색 변경
        myCouponOutlet.setTitleColor(UIColor.newColor_Cranberry, for: .normal)
        myCouponSelectImage.backgroundColor = UIColor.newColor_Cranberry
        couponListOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        couponListBtnSelectImage.backgroundColor = UIColor.white
        
        
        couponListOutlet.isEnabled = true
        myCouponOutlet.isEnabled = false
        
        smartCon_MyConTV.reloadData()

        
    }
    
    // 스마트콘뷰 기본 설정
    func defaultSetting() {
        myCouponOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        myCouponSelectImage.backgroundColor = UIColor.white
        couponListOutlet.setTitleColor(UIColor.newColor_Cranberry, for: .normal)
        couponListBtnSelectImage.backgroundColor = UIColor.newColor_Cranberry
        
        couponListOutlet.roundCorners(corners: [ .topLeft], radius: 30.0)
        myCouponOutlet.roundCorners(corners: [ .topRight], radius: 30.0)
        
        
    }
    
    // 테이블뷰 셀 색션 갯수 생성
    func numberOfSections(in tableView: UITableView) -> Int {
        // return number of section in table from data
        var count:Int?
        if tableView == smartCon_ListTV {
            //            count = list.count
            count = 1
        } else if tableView == smartCon_MyConTV {
            count = 1
        }
        return count!
    }
    
    // 보여질 카테고리 섹션 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of rows in each section from data
        var count:Int?
        
        if tableView == smartCon_ListTV {
            count = cateNameListArray.count
        } else if tableView == smartCon_MyConTV {
            count = myCon_goods_name.count
        }
        return count!
    }
    
    @objc func imageViewTapped_0(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }

        cellSection = 0
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_1(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 1
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_2(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 2
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_3(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 3
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_4(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 4
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_5(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 5
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_6(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 6
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_7(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 7
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_8(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 8
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    @objc func imageViewTapped_9(imageView:UITapGestureRecognizer? = nil ) {
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        if indexCheck != ""  {
            self.goodsListDataLoad()
        }
        cellSection = 9
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    // 테이블 셀 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()

        if tableView == self.smartCon_ListTV!
        {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_0") as! SmartCon_ListCell_0
                
                // 화면 터치 이벤트
                cell.headerView_0.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_0))
                cell.headerView_0.addGestureRecognizer(tapRecognizer)
                
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                
                
                
                if indexPath.row == cellSection {
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
//                        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//                        rotationAnimation.toValue = NSNumber(value: .pi * 1.0)
//                        rotationAnimation.duration = 0.5;
//                        rotationAnimation.isCumulative = true;
//                        rotationAnimation.repeatCount = .infinity
//                        cell.headerView_Btn.layer.add(rotationAnimation, forKey: "rotationAnimation")
                        
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        self.imageRollUpCheck2 = true
                    }

                } else if indexPath.row != cellSection  {
                    cell.headerView_Label.textColor = UIColor.lightGray
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                }
                


                cell.delegate = self
                
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_1") as! SmartCon_ListCell_1
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_1))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)

                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }

                cell.delegate = self
                
                return cell
                
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_2") as! SmartCon_ListCell_2
                // 화면 터치 이벤트
                cell.headerView_2.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_2))
                cell.headerView_2.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }

                cell.delegate = self
                
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_3") as! SmartCon_ListCell_3
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_3))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }

                cell.delegate = self
                
                return cell
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_4") as! SmartCon_ListCell_4
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_4))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }
 
                cell.delegate = self
                
                return cell
            } else if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_5") as! SmartCon_ListCell_5
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_5))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }
  
                cell.delegate = self
                
                return cell
            } else if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_6") as! SmartCon_ListCell_6
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_6))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }

                cell.delegate = self
                
                return cell
            } else if indexPath.row == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_7") as! SmartCon_ListCell_7
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_7))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }

                cell.delegate = self
                
                return cell
            } else if indexPath.row == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_8") as! SmartCon_ListCell_8
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_8))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }
   
                cell.delegate = self
                
                return cell
            } else if indexPath.row == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SmartCon_ListCell_9") as! SmartCon_ListCell_9
                // 화면 터치 이벤트
                cell.headerView_1.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped_9))
                cell.headerView_1.addGestureRecognizer(tapRecognizer)
                // 셀 배경 색
                cell.smartConList_CollCell.backgroundColor = UIColor.white
                if indexPath.row == cellSection {
                    
                    if self.imageRollUpCheck2 == true {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                        cell.headerView_Label.textColor = UIColor.lightGray
                        self.imageRollUpCheck2 = false
                    } else {
                        cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow02")
                        cell.headerView_Label.textColor = UIColor.newColor_Brown
                        self.imageRollUpCheck2 = true
                    }
                    
                } else if indexPath.row != cellSection  {
                    
                    cell.headerView_Btn.image = UIImage(named: "giftshop_list_arrow01")
                    cell.headerView_Label.textColor = UIColor.lightGray
                }

                cell.delegate = self
                
                return cell
            }
            
        }
        
        if tableView == self.smartCon_MyConTV! {
            /*
            print("myCon_tr_id = " + "\(Data_SmartCon_MyCon.shared.myCon_tr_id_array)")
            print("myCon_member_srl = " + "\(Data_SmartCon_MyCon.shared.myCon_member_srl_array)")
            print("myCon_event_id = " + "\(Data_SmartCon_MyCon.shared.myCon_event_id_array)")
            print("myCon_goods_id = " + "\(Data_SmartCon_MyCon.shared.myCon_goods_id_array)")
            print("myCon_goods_id = " + "\(Data_SmartCon_MyCon.shared.myCon_disc_price_array)")
            print("myCon_disc_price = " + "\(Data_SmartCon_MyCon.shared.myCon_disc_rate_array)")
            print("myCon_disc_rate = " + "\(Data_SmartCon_MyCon.shared.myCon_price_array)")
            print("myCon_price = " + "\(Data_SmartCon_MyCon.shared.myCon_order_cnt_array)")
            print("myCon_order_cnt = " + "\(self.myCon_order_cnt)")
            print("myCon_img_url = " + "\(Data_SmartCon_MyCon.shared.myCon_img_url_array)")
            print("myCon_exchange_status = " + "\(Data_SmartCon_MyCon.shared.myCon_exchange_status_array)")
            print("myCon_goods_name = " + "\(Data_SmartCon_MyCon.shared.myCon_goods_name_array)")
            print("myCon_brand_name = " + "\(Data_SmartCon_MyCon.shared.myCon_brand_name_array)")
             */
            
            if myCon_Vali_claim_type.count != myCon_goods_name.count{
                
                return cell

            }
            
            let cell:SmartCon_MyListCell =  (tableView.dequeueReusableCell(withIdentifier: "SmartCon_MyListCell", for: indexPath) as? SmartCon_MyListCell)!
            

            
            // 나의쿠폰 상품 이미지
            if myCon_img_url[indexPath.row] != "" {
                brandImgUrl = myCon_img_url[indexPath.row]
            }
            let url = URL(string: brandImgUrl)
            let data = try? Data(contentsOf: url!)
            let imageData = data
            
            // 나의쿠폰 상품 브랜드명
            if myCon_brand_name[indexPath.row] != ""{
                brandName = myCon_brand_name[indexPath.row]
                brandNameCount = brandName.count
            }
            
            // 나의쿠폰 상품명
            if myCon_goods_name[indexPath.row] != "" {
                titleName = "[" + myCon_brand_name[indexPath.row] + "]"
                let subStringCount = myCon_goods_name[indexPath.row].count - (titleName.count + 1)
                let subtitle = myCon_goods_name[indexPath.row]
                subTitleName = String(subtitle.suffix(subStringCount))
            }
    
            
            if myCon_Vali_claim_type[indexPath.row] == "N" {
                if myCon_Vali_exchange_status[indexPath.row] == "0"{
                    exchange = "사용 가능"
                    cellSelectCheckCnt += 1

                } else if myCon_Vali_exchange_status[indexPath.row] == "1" {
                    exchange = "사용 완료"
                    cellSelectCheckCnt += 1
                    

                } else if myCon_Vali_exchange_status[indexPath.row] == "3" {
                    exchange = "사용 가능"
                    cellSelectCheckCnt += 1
                    
                }
            } else if myCon_Vali_claim_type[indexPath.row] == "CC" {
                exchange = "주문 취소"
                if cellSelectCheckCnt < myCon_Vali_exchange_status.count {

                    cellSelectCheckCnt += 1
                }
                
            } else if myCon_Vali_claim_type[indexPath.row] == "RS" {
                exchange = "환불 요청"
                if cellSelectCheckCnt < myCon_Vali_exchange_status.count {

                    cellSelectCheckCnt += 1
                }
            } else if myCon_Vali_claim_type[indexPath.row] == "RE" {
                exchange = "환불 완료"
                if cellSelectCheckCnt < myCon_Vali_exchange_status.count {

                    cellSelectCheckCnt += 1
                }
            }
            
            if myCon_price[indexPath.row] != "" {
                price = myCon_price[indexPath.row]
                price = (Int(price)?.withComma)! + " P"
            }

            if myCon_Vali_claim_type[indexPath.row] != "N"{
                cell.contentView.alpha = 0.5
                cell.selectionStyle = .none
            }
            if myCon_Vali_claim_type[indexPath.row] == "N"{
                cell.contentView.alpha = 1.0
            }

            cell.myCouponImageView.image = UIImage(data: imageData!)
            cell.goodsTitleLabel?.text = titleName
            cell.goodsSubTitleLabel?.text = subTitleName
            cell.brandNameLabel?.text = myCon_brand_name[indexPath.row]
            cell.goodsPriceLabel?.text = price
            cell.exchangeStatusLabel?.text = exchange
            
            return cell
        }

        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
//        if (self.lastContentOffset < scrollView.contentOffset.y) {
//
//            if self.smartCon_BannerImage.frame.size.height != 0 {
//                UIView.animate(withDuration: 0.2) {
//                    self.smartCon_BannerImage.frame.size.height = 0
//
//
//                    self.smartCon_MyConTV.topAnchor.constraint(equalTo: self.smartConTopView.bottomAnchor, constant: 50.0).isActive = true
//                    self.smartCon_ListTV.topAnchor.constraint(equalTo: self.smartConTopView.bottomAnchor, constant: 50.0).isActive = true
//
//                    if self.imageCollSpanCheck == true {
//                        self.smartConBtnView.frame.origin.y -= self.bannerViewHeight!
//                        self.smartCon_MyConTV.frame.origin.y -= 150.0
//                        self.smartCon_ListTV.frame.origin.y -= 150.0
//                        self.imageCollSpanCheck = false
//                    }
//
//                    self.viewWillAppear(true)
//
//                }
//            }
//
//        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
//            if self.smartCon_BannerImage.frame.size.height == 0 {
//                UIView.animate(withDuration: 0.2) {
////                    self.smartCon_BannerImage.frame.size.height = self.bannerViewHeight!
////                    self.smartConBtnView.frame.origin.y += self.bannerViewHeight!
//
//                    self.smartCon_MyConTV.topAnchor.constraint(equalTo: self.smartConTopView.bottomAnchor, constant: 200.0).isActive = true
//                    self.smartCon_ListTV.topAnchor.constraint(equalTo: self.smartConTopView.bottomAnchor, constant: 200.0).isActive = true
//
//                    self.smartCon_MyConTV.frame.origin.y += 0
//                    self.smartCon_ListTV.frame.origin.y += 0
//                    self.viewWillAppear(true)
//
//                }
//            }
//        } else {
//        }
    }
    
    
    // 테이블뷰 헤더 클릭 할때 열고 닫히는
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat?
        var brandCntHeight = Int(smartCon_brand_Array_Cnt[cellSection])! / 3
        var brandCntHeight2 = Int(smartCon_brand_Array_Cnt[cellSection])! % 3
        var totalHeight = 0
        
        if tableView == smartCon_ListTV {
            
            if cellExpandebleCheck == true {
                
                // 아이템 갯수를 3으로 나누어서 나머지가 없을 때
                if brandCntHeight2 == 0 {
                    
                    if brandCntHeight == 1 && brandCntHeight2 == 0 {
                        listCellExpandCheck = true
                        totalHeight = 190
                    } else {
                        totalHeight = (brandCntHeight * 135) + 50
                        listCellExpandCheck = true
                    }
                    listCellExpandCheck = true
                    brandCntHeight = 0
                    brandCntHeight2 = 0

                } else if brandCntHeight2 != 0 {
                    // 아이템 갯수를 3으로 나누어서 나머지가 있을 때
                    listCellExpandCheck = true
                    totalHeight = ((brandCntHeight + 1) * 135) + 50
                    brandCntHeight = 0
                    brandCntHeight2 = 0

                }

                if indexPath.row == cellSection {
                    height = CGFloat(totalHeight)
                    totalHeight = 0
                    listCellExpandCheck = true
                } else {
                    // 하나 열릴때 나머지 셀 높이
                    height = 50
                    brandCntHeight = 0
                    brandCntHeight2 = 0
                    totalHeight = 0

                }
                
            } else {
                
                if firstLoadCheck == true {
                    firstLoadCheck = false
                    height = 300
                    return height!
                    
                    
                } else {
                    // 모두 닫힐때 나머지 셀 높이
                    height = 50
                    brandCntHeight = 0
                    brandCntHeight2 = 0
                    totalHeight = 0
                    listCellExpandCheck = false

                }
            }
        } else if tableView == smartCon_MyConTV {
            height = 120
        }

        return height!
    }
    
    func smartCon_ListCell_0_Protocol(SmartCon_ListCell_0_Protocol: SmartCon_ListCell_0) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex

            if indexCheck != ""  {
                self.goodsListDataLoad()
            }

        
        cellSection = 0
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_1_Protocol(SmartCon_ListCell_1_Protocol: SmartCon_ListCell_1) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        cellSection = 1
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_2_Protocol(SmartCon_ListCell_2_Protocol: SmartCon_ListCell_2) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        cellSection = 2
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_3_Protocol(SmartCon_ListCell_3_Protocol: SmartCon_ListCell_3) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        cellSection = 3
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_4_Protocol(SmartCon_ListCell_4_Protocol: SmartCon_ListCell_4) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        cellSection = 4
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_5_Protocol(SmartCon_ListCell_5_Protocol: SmartCon_ListCell_5) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }

        cellSection = 5
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_6_Protocol(SmartCon_ListCell_6_Protocol: SmartCon_ListCell_6) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        
        cellSection = 6
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_7_Protocol(SmartCon_ListCell_7_Protocol: SmartCon_ListCell_7) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        
        cellSection = 7
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_8_Protocol(SmartCon_ListCell_8_Protocol: SmartCon_ListCell_8) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        
        cellSection = 8
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func smartCon_ListCell_9_Protocol(SmartCon_ListCell_9_Protocol: SmartCon_ListCell_9) {
        
        let indexCheck = Data_SmartCon.shared.smartCon_SelectBrandImageIndex
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if indexCheck != ""  {
                self.goodsListDataLoad()
            }
        }
        
        
        cellSection = 9
        if cellExpandebleCheck == false {
            cellExpandebleCheck = true
        } else {
            cellExpandebleCheck = false
        }
        smartCon_ListTV.reloadData()
    }
    
    func sendData(data: Array<Any>) {
        self.selectBrand_Goods_Array = data as! [String]
        
    }
    
    // 브랜드 상품 리스트 데이터 불러오기
    func goodsListDataLoad() {
        let event_id = Data_SmartCon.shared.smartCon_EventId
        let brand_code = selectBrand_Goods_Array[2]
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/eventGoodsList"
            let param: Parameters = [
                "event_id" : event_id,
                "brand_code" : brand_code
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                
                switch response.result {
                    
                case .success(let value):
                    self.selectBrand_ListData = JSON(value)
                    
                    Data_SmartCon_Goods.shared.smartCon_Goods_disc_price = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["disc_price"].stringValue})
                    Data_SmartCon_Goods.shared.smartCon_Goods_disc_rate = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["disc_rate"].stringValue})
                    Data_SmartCon_Goods.shared.smartCon_Goods_goods_id = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["goods_id"].stringValue})
                    Data_SmartCon_Goods.shared.smartCon_Goods_goods_name = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["goods_name"].stringValue})
                    Data_SmartCon_Goods.shared.smartCon_Goods_img_url = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["img_url"].stringValue})
                    Data_SmartCon_Goods.shared.smartCon_Goods_msg = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["msg"].stringValue})
                    Data_SmartCon_Goods.shared.smartCon_Goods_price = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["price"].stringValue})
                    Data_SmartCon_Goods.shared.smartCon_Goods_cancelable = self.selectBrand_ListData["goodsArr"][0]["smartcon_arr"].arrayValue.map({$0["cancelable"].stringValue})

                    
                    /*
                                        print("")
                                        print("//////////////////////////// 브랜드 정보 불러오기 //////////////////////////////")
                                        print("SmartCon_Brand_disc_price = " + "\( Data_SmartCon_Goods.shared.smartCon_Goods_disc_price)")
                                        print("SmartCon_Brand_disc_rate = " + "\(Data_SmartCon_Goods.shared.smartCon_Goods_disc_rate)")
                                        print("SmartCon_Brand_goods_id = " + "\(Data_SmartCon_Goods.shared.smartCon_Goods_goods_id)")
                                        print("SmartCon_Brand_goods_name = " + "\(Data_SmartCon_Goods.shared.smartCon_Goods_goods_name)")
                                        print("SmartCon_Brand_img_url = " + "\(Data_SmartCon_Goods.shared.smartCon_Goods_img_url)")
                                        print("SmartCon_Brand_msg = " + "\(Data_SmartCon_Goods.shared.smartCon_Goods_msg)")
                                        print("SmartCon_Brand_price = " + "\(Data_SmartCon_Goods.shared.smartCon_Goods_price)")
                                        print("SmartCon_Brand_cancelable = " + "\(Data_SmartCon_Goods.shared.smartCon_Goods_cancelable)")
                                        print("//////////////////////////////////////////////////////////////////////////////////")
                                        print("")
*/

                    Data_SmartCon.shared.smartCon_SelectBrandImageIndex = ""
                    let when = DispatchTime.now() + 0.1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SmartCon_BrandStoryID")
                        
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexNum = indexPath.row
        
        if myCon_Vali_claim_type[indexPath.row] == "N" {
            
            myCon_Vali_Detail_Data.append(myCon_Vali_claim_type[indexNum]) // 0
            myCon_Vali_Detail_Data.append(myCon_Vali_valid_start[indexNum])  // 1
            myCon_Vali_Detail_Data.append(myCon_Vali_valid_end[indexNum]) // 2
            myCon_Vali_Detail_Data.append(myCon_Vali_cancel_period[indexNum]) // 3
            myCon_Vali_Detail_Data.append(myCon_Vali_tr_id[indexNum]) // 4
            myCon_Vali_Detail_Data.append(myCon_Vali_exchange_date[indexNum]) // 5
            myCon_Vali_Detail_Data.append(myCon_Vali_order_date[indexNum]) // 6
            myCon_Vali_Detail_Data.append(myCon_Vali_exchange_status[indexNum]) // 7
            myCon_Vali_Detail_Data.append(myCon_Vali_cancelable[indexNum]) // 8
            myCon_Vali_Detail_Data.append(myCon_img_url[indexNum]) // 9
            myCon_Vali_Detail_Data.append(myCon_price[indexNum]) // 10
            myCon_Vali_Detail_Data.append(myCon_brand_name[indexNum]) // 11
            myCon_Vali_Detail_Data.append(myCon_goods_name[indexNum]) // 12
            
            
            Data_SmartCon_MyCon_Vali.shared.myCon_Vali_Detail_Data = myCon_Vali_Detail_Data
            
            myCon_Vali_Detail_Data.removeAll()
            
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SmartCon_MyCoupon_DetailStoryID")
                
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        
        let itemCnt1 = self.myCon_goods_name.count
        let itemCnt2 = Int(self.myCon_total_cnt)
        
        if  itemCnt1 > itemCnt2! || itemCnt1 == itemCnt2! {
            return
        } else {
            if smartCon_MyConTV.isUserInteractionEnabled == false {
                return
            } else if myCon_Vali_Data_Load_Status == true {
                myCon_Vali_Data_Load_Status = false
                self.smartCon_Activity.isHidden = false
                
                self.smartCon_Activity.startAnimating()
                self.myCouponListLoad()
            }
        }
    }
    
    // 보유쿠폰 데이터 불러오기
    func myCouponListLoad() {

        let member_srl = Data_MemberInfo.shared.member_srl
        let start_num = String(myCon_start_num_add)
        let list_num = "5"

        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/myCoupon"
            let param: Parameters = [
                "member_srl" : member_srl,
                "start_num" : start_num,
                "list_num" : list_num
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                    
                case .success(let value):
                    self.myConListData = JSON(value)
                    self.myCon_tr_id_add.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["tr_id"].stringValue}))
                    self.myCon_tr_id.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["tr_id"].stringValue}))
                    self.myCon_member_srl.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["member_srl"].stringValue}))
                    self.myCon_event_id.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["event_id"].stringValue}))
                    self.myCon_goods_id.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["goods_id"].stringValue}))
                    self.myCon_disc_price.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["disc_price"].stringValue}))
                    self.myCon_disc_rate.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["disc_rate"].stringValue}))
                    self.myCon_price.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["price"].stringValue}))
                    self.myCon_order_cnt.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["order_cnt"].stringValue}))
                    self.myCon_img_url.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["img_url"].stringValue}))
                    self.myCon_exchange_status.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["exchange_status"].stringValue}))
                    self.myCon_goods_name.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["goods_name"].stringValue}))
                    self.myCon_brand_name.append(contentsOf: self.myConListData["couponArr"].arrayValue.map({$0["brand_name"].stringValue}))
                    
                    /*
                     
                     print("myCon_tr_id = " + "\(self.myCon_tr_id)")
                     print("myCon_member_srl = " + "\(self.myCon_member_srl)")
                     print("myCon_event_id = " + "\(self.myCon_event_id)")
                     print("myCon_goods_id = " + "\(self.myCon_goods_id)")
                     print("myCon_goods_id = " + "\(self.myCon_goods_id)")
                     print("myCon_disc_price = " + "\(self.myCon_disc_price)")
                     print("myCon_disc_rate = " + "\(self.myCon_disc_rate)")
                     print("myCon_price = " + "\(self.myCon_price)")
                     print("myCon_order_cnt = " + "\(self.myCon_order_cnt)")
                     print("myCon_img_url = " + "\(self.myCon_img_url)")
                     print("myCon_exchange_status = " + "\(self.myCon_exchange_status)")
                     print("myCon_goods_name = " + "\(self.myCon_goods_name)")
                     print("myCon_brand_name = " + "\(self.myCon_brand_name)")
                     
                     */
                    
                    self.myCon_start_num_add += 5
                    

                        if self.myCon_tr_id.count != 0 {
                            self.myCouponStatusLoad()
                        }

                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    // 스마트콘 실시간 교환상태 조회
    func myCouponStatusLoad() {

        if cnt >= 5 {
            self.myCon_tr_id_add.removeAll()
            self.cnt = 0
            self.smartCon_MyConTV.reloadData()
            self.smartCon_Activity.isHidden = true
            self.smartCon_Activity.stopAnimating()
            self.myCon_Vali_Data_Load_Status = true
            return
        }
        if self.myCon_tr_id_add.count != 5 {
            if cnt + 1 > self.myCon_tr_id_add.count {
                self.myCon_Vali_Data_Load_Status = true
                self.smartCon_Activity.isHidden = true
                self.smartCon_Activity.stopAnimating()
                return
            }
        }
        let tr_id  = self.myCon_tr_id_add[cnt]
        let event_id = Data_SmartCon.shared.smartCon_EventId
        
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/smartcon/validateCoupon"
            
            let param: Parameters = [
                "tr_id" : tr_id,
                "event_id" : event_id
            ]
            
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in

                switch response.result {
                    
                case .success(let value):
                    self.myConList_ValiData = JSON(value)
                    let test1 = self.myConList_ValiData["claim_type"].string!
                    let test2 = self.myConList_ValiData["valid_start"].string!
                    let test3 = self.myConList_ValiData["valid_end"].string!
                    let test4 = self.myConList_ValiData["tr_id"].string!
                    let test5 = self.myConList_ValiData["exchange_date"].string!
                    let test6 = self.myConList_ValiData["order_date"].string!
                    let test7 = self.myConList_ValiData["exchange_status"].string!
                    let test8 = self.myConList_ValiData["cancel_period"].string!
                    let test9 = self.myConList_ValiData["cancelable"].string!

                    self.myCon_Vali_claim_type.append(test1)
                    self.myCon_Vali_valid_start.append(test2)
                    self.myCon_Vali_valid_end.append(test3)
                    self.myCon_Vali_tr_id.append(test4)
                    self.myCon_Vali_exchange_date.append(test5)
                    self.myCon_Vali_order_date.append(test6)
                    self.myCon_Vali_exchange_status.append(test7)
                    self.myCon_Vali_cancel_period.append(test8)
                    self.myCon_Vali_cancelable.append(test9)

                    if self.cnt < 5  {
                        self.cnt += 1
                        self.myCouponStatusLoad()
                    }
                    
                    /*
                    print(self.myCon_Vali_claim_type)
                    print(self.myCon_Vali_valid_start)
                    print(self.myCon_Vali_valid_end)
                    print(self.myCon_Vali_tr_id)
                    print(self.myCon_Vali_exchange_date)
                    print(self.myCon_Vali_order_date)
                    print(self.myCon_Vali_exchange_status)
                    print(self.myCon_Vali_cancel_period)
                    print(self.myCon_Vali_cancelable)
                    */
                    
                    self.myCon_Vali_Data_Load_Status = true
                    self.smartCon_Activity.isHidden = true
                    self.smartCon_Activity.stopAnimating()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    
    
    
}

// sub class the section header class to add a section number so we can pass it with the tap guestre
class ExpandableHeader: UITableViewHeaderFooterView {
    var section: Int = 0
}
