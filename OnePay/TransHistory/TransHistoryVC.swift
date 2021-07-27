//
//  TransHistoryVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 8..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TransHistoryVC: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var transHistoryTV: UITableView!
    @IBOutlet weak var transHistoryStartDayBtnOutlet: UIButton!
    @IBOutlet weak var transHistoryEndDayBtnOutlet: UIButton!
    @IBOutlet weak var transHistoryLookUpBtnOutlet: UIButton!
    @IBOutlet weak var transHistorySlideMenuBtnOutlet: UIButton!
    @IBOutlet weak var transTotalPointLabel: UILabel!
    @IBOutlet weak var transTotalDumLabel: UILabel!
    @IBOutlet weak var transHistoryStatusLabel: UILabel!
    @IBOutlet var transHistoryView: UIView!
    @IBOutlet weak var btn_tranCheck: UIButton!
    
    @objc var aPopupContainer: PopupContainer?
    @objc var testCalendar = Calendar(identifier: .gregorian)
    @objc var currentDate: Date! = Date() {
        didSet {
            setDate()
        }
    }
    
    let serviceUrl = UrlData()
    var startDayCheck:Bool = false
    var endDayCheck:Bool = false
    var timeNow = Date()
    var refresher: UIRefreshControl!
    var transHitoryData:JSON = JSON.init(rawValue: [])!
    var pay_type:[String] = []
    var point_total:[String] = []
    var total_amt:[String] = []
    var tran_time:[String] = []
    var tran_type:[String] = []
    var tran_Data:[Any] = []
    var total_amt_Sum:[Int] = []
    var point_total_Sum:[Int] = []
    var generator:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_tranCheck.layer.cornerRadius = 10
        
        transHistoryView.onSwipeLeft{ _ in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_ServiceCenter")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        
        transHistoryView.onSwipeRight{ _ in
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            
            self.transHistorySlideMenuBtnOutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
//            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
            self.view.addGestureRecognizer(revealVC.tapGestureRecognizer())
        }
        
        defaultSettings()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 거래내역 조회 시작일 선택 버튼
    @IBAction func transHistoryStartDayBtn(_ sender: Any) {
        startDayCheck = true
        
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        xibView.startDate = Calendar.current.date(byAdding: .month, value: -12, to: currentDate)!
        PopupContainer.generatePopupWithView(xibView).show()
        
    }
    
    // 거래내역 조회 종료일 선택 버튼
    @IBAction func transHistoryEndDayBtn(_ sender: Any) {
        endDayCheck = true
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        xibView.startDate = Calendar.current.date(byAdding: .month, value: -12, to: currentDate)!
        
        PopupContainer.generatePopupWithView(xibView).show()
    }
    
    // 거래내역 조회 결과 버튼
    @IBAction func transHistoryLookUpBtn(_ sender: Any) {
        
        self.total_amt.removeAll()
        self.tran_time.removeAll()
        self.tran_type.removeAll()
        self.point_total.removeAll()
        self.total_amt_Sum.removeAll()
        self.point_total_Sum.removeAll()
        
        let start_date = Data_Calendar.shared.start_day
        let end_date = Data_Calendar.shared.end_day
        let time_now = Data_Calendar.shared.current_Date
        
        let s_day = start_date.components(separatedBy: ["-"]).joined()
        let e_day = end_date.components(separatedBy: ["-"]).joined()
        let t_now = time_now.components(separatedBy: ["-"]).joined()
        
        var int_sday = Int(s_day)
        var int_eday = Int(e_day)
        
        if start_date == "" {
            int_sday = Int(t_now)
        } else if end_date == "" {
            int_eday = Int(t_now)
        } else if int_sday! > int_eday! {
            displayMsg(title: "원페이", msg: "조회기간을 확인해주세요.")
            return
        }
        
        transHistoryDataLoad()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tran_time.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransHistoryCell", for: indexPath) as! TransHistoryCell
        
        // 덤 있는 셀
        cell.transHistoryCellDateLabel?.text = tran_time[indexPath.row]
        cell.transHistoryCellPointLabel?.text = total_amt[indexPath.row]
        cell.transHistoryCellDumLabel?.text = point_total[indexPath.row]
        cell.transHistoryCellPayTypeLabel?.text =  pay_type[indexPath.row] + " " + tran_type[indexPath.row]
        
        
        // 덤 없는 셀
//        cell.transHistoryCellDateLabel?.text = tran_time[indexPath.row]
//        cell.transHistoryCellPointLabel?.text =
//        cell.transHistoryCellDumLabel?.text = total_amt[indexPath.row]
        

        if tran_type[indexPath.row] == "별 적립" {
            cell.transHistoryCellPayTypeLabel?.text = tran_type[indexPath.row]
        } else {
            cell.transHistoryCellPayTypeLabel?.text =  pay_type[indexPath.row] + " " + tran_type[indexPath.row]
        }
        
        
        
        return cell
    }
    
    // 테이블뷰 데이터 리로드
    func reroad(){
        print("리로드데이타")
        let intPointArr = total_amt_Sum
        let pointSum = intPointArr.reduce(0, +)
        let pointTotal = Int(pointSum).withComma
        


        
        // 덤 있는 레이블
        let intDumArr = point_total_Sum
        let dumSum = intDumArr.reduce(0, +)
        let dumTotal = Int(dumSum).withComma
        transTotalPointLabel?.text = String(pointTotal) + " P"
        transTotalDumLabel?.text = String(dumTotal) + " 별"
        
        // 덤 없는 레이블
//        transTotalDumLabel?.text = String(pointTotal) + " P"
        
        transHistoryTV.reloadData()
        refresher.endRefreshing()
    }
    
    
    // 기본 셋팅
    func defaultSettings(){

        refresher = UIRefreshControl()
        transHistoryTV.delegate = self
         currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let time = formatter.string(from: currentDate)
        Data_Calendar.shared.current_Date = time
        Data_Calendar.shared.start_day = time
        Data_Calendar.shared.end_day = time
        
        
        transHistoryStartDayBtnOutlet.setTitle("\(time)",for: UIControl.State.normal)
        transHistoryEndDayBtnOutlet.setTitle("\(time)",for: UIControl.State.normal)
        transHistoryLookUpBtnOutlet.setTitle("거래내역 조회",for: UIControl.State.normal)
        
//        transHistoryStartDayBtnOutlet.layer.borderColor = UIColor.init(red:195/255.0, green:155/255.0, blue:69/255.0, alpha: 1.0).cgColor
//        transHistoryStartDayBtnOutlet.layer.borderWidth = 2
//        transHistoryEndDayBtnOutlet.layer.borderColor = UIColor.init(red:195/255.0, green:155/255.0, blue:69/255.0, alpha: 1.0).cgColor
//        transHistoryEndDayBtnOutlet.layer.borderWidth = 2
        
    }
    
    
    // 달력 셋팅
    @objc func setDate() {
        let year = testCalendar.dateComponents([.year], from: currentDate).year!
        let month = testCalendar.dateComponents([.month], from: currentDate).month!
        //        let weekday = testCalendar.component(.weekday, from: currentDate)
//                let monthName = DateFormatter().monthSymbols[(month-1) % 12] //GetHumanDate(month: month)//
        //        let week = DateFormatter().shortWeekdaySymbols[weekday-1]
        let day = testCalendar.component(.day, from: currentDate)
//        let monthName = GetHumanDate(month: month)
        
        var generationMonth = ""
        var generationDay = ""
        
        if month < 10 {
            generationMonth = "0" + "\(month)"
        } else {
            generationMonth = "\(month)"
        }
        
        if day < 10 {
            generationDay = "0" + "\(day)"
        } else {
            generationDay = "\(day)"
        }
        
        let date = "\(year)-" + "\(generationMonth)-" + "\(generationDay)"
        
        if startDayCheck == true {
            transHistoryStartDayBtnOutlet.setTitle(date,for: UIControl.State.normal)
            Data_Calendar.shared.start_day = date
            startDayCheck = false
        } else if  endDayCheck == true {
            transHistoryEndDayBtnOutlet.setTitle(date,for: UIControl.State.normal)
            Data_Calendar.shared.end_day = date
            endDayCheck = false
        }
        
    }
    
    
    // 회원 자산 조회
    func transHistoryDataLoad() {
        print("거래내역 조회시작")
        let member_srl = Data_MemberInfo.shared.member_srl
        let start_date = Data_Calendar.shared.start_day
        let end_date = Data_Calendar.shared.end_day
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/payHistory"
            let param: Parameters = [
                "member_srl": member_srl,
                "start_date": start_date,
                "end_date": end_date
            ]

            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                case .success(let value):
                    
                    self.transHitoryData = JSON(value)
                    let tranArr = self.transHitoryData["tranArr"]
                    
                    let string = String(describing: tranArr)
                    // string 을 data 형식으로 변환
                    let jsonData = string.data(using: .utf8)!
                    do {
                        // Serialize the json Data and cast it into Array of Dictionary
                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String: Any]]
                        // tran_type 필터
                        let tranArrSorted = jsonObject?.filter({ (dictionary) -> Bool in
                            dictionary["tran_type"] as? String != ""
                        })
                        self.tran_Data = tranArrSorted!
                        
                    } catch {
                        print(error)
                    }
                    
                    var point_total_Arr:[Dictionary<String, Any>] = []
                    point_total_Arr = self.tran_Data as! [Dictionary<String, Any>]
                    for point_total_Add in point_total_Arr {
                        self.generator = "\(point_total_Add["point_total"] ?? String.self)"
                        let point = Int(self.generator)
                        let result = Int(self.generator)?.withComma
                        self.point_total_Sum.append(point!)
                        self.point_total.append(result! + " 덤")
                        
                    }
                    
                    var total_amt_Arr:[Dictionary<String, Any>] = []
                    total_amt_Arr = self.tran_Data as! [Dictionary<String, Any>]
                    for total_amt_Add in total_amt_Arr {
                        self.generator = "\(total_amt_Add["total_amt"] ?? String.self)"
                        let point = Int(self.generator)
                        let result = Int(self.generator)?.withComma
                        self.total_amt_Sum.append(point!)
                        self.total_amt.append(result! + " P")
                    }

                    var tran_type_Arr:[Dictionary<String, Any>] = []
                    tran_type_Arr = self.tran_Data as! [Dictionary<String, Any>]
                    for tran_type_Add in tran_type_Arr {
                        self.generator = "\(tran_type_Add["tran_type"] ?? String.self)"
                        switch self.generator {
                        case "P0" :
                            self.generator = "이용료 납부"
                        case "D1" :
                            self.generator = "사용 주문"
                        case "D2" :
                            self.generator = "취소"
                        case "C0" :
                            self.generator = "충전"
                        case "C1" :
                            self.generator = "송금"
                        case "C2" :
                            self.generator = "회원간 입금"
                        case "C3" :
                            self.generator = "회원간 송금"
                        case "M1" :
                            self.generator = "적립"
                        case "M2" :
                            self.generator = "적립취소"
                        case "T1" :
                            self.generator = "전환"
                        case "P2" :
                            self.generator = "지급차감"
                        case "B0" :
                            self.generator = "별 적립"
                        default:
                            print("error")
                        }

                        self.tran_type.append("\(self.generator)")
                    }
                    
                    var pay_type_Arr:[Dictionary<String, Any>] = []
                    pay_type_Arr = self.tran_Data as! [Dictionary<String, Any>]
                    for pay_type_Add in pay_type_Arr {
                        self.generator = "\(pay_type_Add["pay_type"] ?? String.self)"
                        switch self.generator {
                        case "01" :
                            self.generator = "현금"
                        case "02" :
                            self.generator = "카드"
                        case "03" :
                            self.generator = "상품권"
                        case "05" :
                            self.generator = "포인트"
                        case "09" :
                            self.generator = "기타"
                        default:
                            print("error")
                        }
                        
                        self.pay_type.append("\(self.generator)")
                    }
                    
                    var tran_time_Arr:[Dictionary<String, Any>] = []
                    tran_time_Arr = self.tran_Data as! [Dictionary<String, Any>]
                    for tran_time_Add in tran_time_Arr {
                        self.generator = "\(tran_time_Add["tran_time"] ?? String.self)"
                        
                        let monthStartIndex = self.generator.index(self.generator.startIndex, offsetBy: 4)
                        let monthEndIndex = self.generator.index(self.generator.startIndex, offsetBy: 6)
                        let dayStartIndex = self.generator.index(self.generator.startIndex, offsetBy: 6)
                        let dayEndIndex = self.generator.index(self.generator.startIndex, offsetBy: 8)
                        let hourStartIndex = self.generator.index(self.generator.startIndex, offsetBy: 9)
                        let hourEndIndex = self.generator.index(self.generator.startIndex, offsetBy: 11)
                        let minStartIndex = self.generator.index(self.generator.startIndex, offsetBy: 11)
                        let minEndIndex = self.generator.index(self.generator.startIndex, offsetBy: 13)
                        let secStartIndex = self.generator.index(self.generator.startIndex, offsetBy: 13)
                        let secEndIndex = self.generator.index(self.generator.startIndex, offsetBy: 15)
                        
                        let year = self.generator.prefix(4)
                        let month = self.generator[monthStartIndex..<monthEndIndex]
                        let day = self.generator[dayStartIndex..<dayEndIndex]
                        let hour = self.generator[hourStartIndex..<hourEndIndex]
                        let min = self.generator[minStartIndex..<minEndIndex]
                        let sec = self.generator[secStartIndex..<secEndIndex]
                        let generator_total1:String = year + "년 " + month + "월 " + day + "일" + "\n"
                        let generator_total2:String = hour + "시 " + min + "분 " + sec + "초"
                        self.tran_time.append(generator_total1 + generator_total2)
                    }
                    
                    if self.total_amt.isEmpty {
                        self.transHistoryStatusLabel?.text = "- 거래내역이 없습니다 -"
                    } else {
                        self.transHistoryStatusLabel?.text = "- 거래내역 조회 완료 -"
                    }
                    
                    self.reroad()
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
        
    }
}

extension TransHistoryVC: CalendarPopUpDelegate {
    @objc func dateChaged(date: Date) {
        currentDate = date
    }
}
