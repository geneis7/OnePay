//
//  ChargeHistoryVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 8..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ChargeHistoryVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var chargeHistoryTV: UITableView!
    @IBOutlet weak var chargeHistorySlideBtnoutlet: UIButton!
    @IBOutlet weak var chargeHistoryStartDayBtnOutlet: UIButton!
    @IBOutlet weak var chargeHistoryEndDayBtnOutlet: UIButton!
    @IBOutlet weak var chargeHistoryLookUpBtnOutlet: UIButton!
    @IBOutlet weak var chargeTotalPointLabel: UILabel!
    @IBOutlet weak var chargeHistoryStatusLabel: UILabel!
    @IBOutlet weak var myHavePointLabel: UILabel!
    @IBOutlet var chargehistoryView: UIView!
    @IBOutlet weak var btn_chargeCheck: UIButton!
    
    let serviceUrl = UrlData()
    var startDayCheck:Bool = false
    var endDayCheck:Bool = false
    var timeNow = Date()
    var refresher: UIRefreshControl!
    var chargeHitoryData:JSON = JSON.init(rawValue: [])!
    var pay_type:[String] = []
    var point_total:[String] = []
    var total_amt:[String] = []
    var tran_time:[String] = []
    var tran_type:[String] = []
    var tran_Data:[Any] = []
    var total_amt_Sum:[Int] = []
    var generator:String = ""

    @objc var aPopupContainer: PopupContainer?
    @objc var testCalendar = Calendar(identifier: .gregorian)
    @objc var currentDate: Date! = Date() {
        didSet {
            setDate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_chargeCheck.layer.cornerRadius = 10
        chargeTotalPointLabel.layer.cornerRadius = 10
        
        
        chargehistoryView.onSwipeLeft{ _ in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_TransHistory")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
        
        chargehistoryView.onSwipeRight{ _ in
            self.navigationController?.popViewController(animated: true)
            
        }

        // 메인 컨트롤러의 참조 정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            
            self.chargeHistorySlideBtnoutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
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
    
    // 충전내역조회 시작일 선택
    @IBAction func chargeHistoryStartDayBtn(_ sender: Any) {
        startDayCheck = true
        
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        xibView.startDate = Calendar.current.date(byAdding: .month, value: -12, to: currentDate)!
        PopupContainer.generatePopupWithView(xibView).show()
    }
    
    // 충전내역조회 종료일 선택
    @IBAction func chargeHistoryEndDayBtn(_ sender: Any) {
        endDayCheck = true
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        xibView.startDate = Calendar.current.date(byAdding: .month, value: -12, to: currentDate)!
        
        PopupContainer.generatePopupWithView(xibView).show()
    }
    
    // 충전내역 조회 버튼
    @IBAction func chargeHistoryLookUpBtn(_ sender: Any) {
        
        self.total_amt.removeAll()
        self.tran_time.removeAll()
        self.total_amt_Sum.removeAll()
        
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
        
        chargeHistoryDataLoad()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tran_time.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChargeHistoryCell", for: indexPath) as! ChargeHistoryCell
        
        cell.chargeHistoryCellDateLabel?.text = tran_time[indexPath.row]
        cell.chargeHistoryCellPointLabel?.text = total_amt[indexPath.row]
        return cell
    }
    
    // 테이블뷰 데이터 리로드
    func reroad(){
        print("리로드데이타")
        let intPointArr = total_amt_Sum
        let sum = intPointArr.reduce(0, +)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let sumtotal = Int(sum)
        let result = numberFormatter.string(from: NSNumber(value:sumtotal))!
        chargeTotalPointLabel?.text = String(result) + " P 충전"
        chargeHistoryTV.reloadData()
        refresher.endRefreshing()
    }
    
    
    // 기본 셋팅
    func defaultSettings(){
        
        var myPoint = Data_MemberAsset.shared.cash_bal
        if myPoint == "" {
            myPoint = "0"
        }

        let point = Int(myPoint)?.withComma

        self.myHavePointLabel?.text = String(describing: point!)
        self.myHavePointLabel.numberOfLines = 0
        self.myHavePointLabel.lineBreakMode = .byWordWrapping
        self.myHavePointLabel.sizeToFit()

        refresher = UIRefreshControl()
        currentDate = Date()
        chargeHistoryTV.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let time = formatter.string(from: currentDate)
        Data_Calendar.shared.current_Date = time
        Data_Calendar.shared.start_day = time
        Data_Calendar.shared.end_day = time
        
        chargeHistoryStartDayBtnOutlet.setTitle("\(time)",for: UIControl.State.normal)
        chargeHistoryEndDayBtnOutlet.setTitle("\(time)",for: UIControl.State.normal)
        chargeHistoryLookUpBtnOutlet.setTitle("충전내역 조회",for: UIControl.State.normal)
        
//        chargeHistoryStartDayBtnOutlet.layer.borderColor = UIColor.init(red:171/255.0, green:0/255.0, blue:51/255.0, alpha: 1.0).cgColor
//        chargeHistoryStartDayBtnOutlet.layer.borderWidth = 2
//        chargeHistoryEndDayBtnOutlet.layer.borderColor = UIColor.init(red:171/255.0, green:0/255.0, blue:51/255.0, alpha: 1.0).cgColor
//        chargeHistoryEndDayBtnOutlet.layer.borderWidth = 2

    }
    
    // 달력 셋팅
    @objc func setDate() {
        let year = testCalendar.dateComponents([.year], from: currentDate).year!
        let month = testCalendar.dateComponents([.month], from: currentDate).month!
        //        let weekday = testCalendar.component(.weekday, from: currentDate)
        //        let monthName = DateFormatter().monthSymbols[(month-1) % 12] //GetHumanDate(month: month)//
        //        let week = DateFormatter().shortWeekdaySymbols[weekday-1]
        let day = testCalendar.component(.day, from: currentDate)
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
            chargeHistoryStartDayBtnOutlet.setTitle(date,for: UIControl.State.normal)
            Data_Calendar.shared.start_day = date
            startDayCheck = false
        } else if  endDayCheck == true {
            chargeHistoryEndDayBtnOutlet.setTitle(date,for: UIControl.State.normal)
            Data_Calendar.shared.end_day = date
            endDayCheck = false
        }
    }
    
    // 회원 자산 조회
    func chargeHistoryDataLoad() {
        print("충전내역 조회시작")
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
            print(param)
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                switch response.result {
                case .success(let value):
                    self.chargeHitoryData = JSON(value)
                    let tranArr = self.chargeHitoryData["tranArr"]

                    let string = String(describing: tranArr)
                    // string 을 data 형식으로 변환
                    let jsonData = string.data(using: .utf8)!
                    do {
                        // Serialize the json Data and cast it into Array of Dictionary
                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String: Any]]
                        // tran_type 필터
                        let tranArrSorted = jsonObject?.filter({ (dictionary) -> Bool in
                            dictionary["tran_type"] as? String == "C0"
                        })
                        self.tran_Data = tranArrSorted!
                        
                    } catch {
                        print(error)
                    }
                    
                    var total_amt_Arr:[Dictionary<String, Any>] = []
                    total_amt_Arr = self.tran_Data as! [Dictionary<String, Any>]
                    for total_amt_Add in total_amt_Arr {
                        self.generator = "\(total_amt_Add["total_amt"] ?? String.self)"
                        let point = Int(self.generator)
                        let result = Int(self.generator)?.withComma
                        self.total_amt_Sum.append(point!)
                        self.total_amt.append(result! + " P 충전")
                        
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
                        self.chargeHistoryStatusLabel?.text = "- 충전내역이 없습니다 -"
                    } else {
                        self.chargeHistoryStatusLabel?.text = "- 충전내역 조회 완료 -"
                    }
                    self.reroad()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension ChargeHistoryVC: CalendarPopUpDelegate {
    @objc func dateChaged(date: Date) {
        currentDate = date
    }
}


