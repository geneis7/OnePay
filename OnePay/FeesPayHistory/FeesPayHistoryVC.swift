//
//  FeesPayHistoryVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 16..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class FeesPayHistoryVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var feesPayHistoryTV: UITableView!
    @IBOutlet weak var feesPayHistoryStartDayBtnOutlet: UIButton!
    @IBOutlet weak var feesPayHistoryEndDayBtnOutlet: UIButton!
    @IBOutlet weak var feesPayHistoryLookUpBtnOutlet: UIButton!
    @IBOutlet weak var feesPayHistoryStatusLabel: UILabel!
    @IBOutlet weak var feesPayHistoryTotalPointLabel: UILabel!
    
    
    

    let serviceUrl = UrlData()
    var startDay:Bool = false
    var EndDay:Bool = false
    var timeNow = Date()
    var refresher: UIRefreshControl!
    var feesPayHistoryData:JSON = JSON.init(rawValue: [])!
    var dues_type:[String] = []
    var dues_month:[String] = []
    var dues_amount:[String] = []
    var ins_dt:[String] = []
    var dues_amount_Sum:[Int] = []
    var dues_Data:[Any] = []
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

        defaultSettings()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func feesPayHistoryStartDayBtn(_ sender: Any) {
        startDay = true
        
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        xibView.startDate = Calendar.current.date(byAdding: .month, value: -12, to: currentDate)!
        PopupContainer.generatePopupWithView(xibView).show()

    }
    
    @IBAction func feesPayHistoryEndDayBtn(_ sender: Any) {
        EndDay = true
        
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        xibView.startDate = Calendar.current.date(byAdding: .month, value: -12, to: currentDate)!
        PopupContainer.generatePopupWithView(xibView).show()

    }
    
    @IBAction func feesPayHistoryLookUpBtn(_ sender: Any) {

        self.dues_type.removeAll()
        self.dues_month.removeAll()
        self.dues_amount.removeAll()
        self.dues_amount_Sum.removeAll()
        self.ins_dt.removeAll()
        
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
        
        feesPayHistoryDataLoad()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ins_dt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeesPayHistoryCell", for: indexPath) as! FeesPayHistoryCell
        print("테이블뷰 리로드")

        cell.feesPayHistoryCellDateLabel?.text = ins_dt[indexPath.row]
        cell.feesPayHistoryCellTypeLabel?.text = dues_type[indexPath.row]
        cell.feesPayHistoryCellPointLabel?.text = dues_amount[indexPath.row]
        cell.feesPayHistoryCellUseDateLabel?.text = dues_month[indexPath.row]
 
        return cell
    }
  
    
    // 테이블뷰 데이터 리로드
    func reroad(){
        print("리로드데이타")
        print(ins_dt)
        print(dues_type)
        print(dues_amount)
        print(dues_month)
        
        let intPointArr = dues_amount_Sum
        let sum = intPointArr.reduce(0, +)
        let sumtotal = Int(sum).withComma
        
        feesPayHistoryTotalPointLabel?.text = String(sumtotal) + " P"
        feesPayHistoryTV.reloadData()
        refresher.endRefreshing()
        
    }
    
    
    func defaultSettings(){
  
        refresher = UIRefreshControl()
        currentDate = Date()
        feesPayHistoryTV.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let time = formatter.string(from: timeNow)
        Data_Calendar.shared.current_Date = time
        Data_Calendar.shared.start_day = time
        Data_Calendar.shared.end_day = time
    
        feesPayHistoryStartDayBtnOutlet.setTitle("\(time)",for: UIControl.State.normal)
        feesPayHistoryEndDayBtnOutlet.setTitle("\(time)",for: UIControl.State.normal)
        feesPayHistoryLookUpBtnOutlet.setTitle("이용료 납부 조회",for: UIControl.State.normal)
        
        feesPayHistoryStartDayBtnOutlet.layer.borderColor = UIColor.init(red:195/255.0, green:155/255.0, blue:69/255.0, alpha: 1.0).cgColor
        feesPayHistoryStartDayBtnOutlet.layer.borderWidth = 2
        feesPayHistoryEndDayBtnOutlet.layer.borderColor = UIColor.init(red:195/255.0, green:155/255.0, blue:69/255.0, alpha: 1.0).cgColor
        feesPayHistoryEndDayBtnOutlet.layer.borderWidth = 2
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
        
        if startDay == true {
            feesPayHistoryStartDayBtnOutlet.setTitle(date,for: UIControl.State.normal)
            Data_Calendar.shared.start_day = date
            startDay = false
        } else if  EndDay == true {
            feesPayHistoryEndDayBtnOutlet.setTitle(date,for: UIControl.State.normal)
            Data_Calendar.shared.end_day = date
            EndDay = false
        }
    }
    
    // 이용료 납부 내역 조회
    func feesPayHistoryDataLoad() {
        print("충전내역 조회시작")
        let member_srl = Data_MemberInfo.shared.member_srl
        let start_date = Data_Calendar.shared.start_day
        let end_date = Data_Calendar.shared.end_day
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/duesHistory"
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
                    self.feesPayHistoryData = JSON(value)
                    print(self.feesPayHistoryData)
                    let duesArr = self.feesPayHistoryData["duesArr"]
                    let string = String(describing: duesArr)
                    // string 을 data 형식으로 변환
                    let jsonData = string.data(using: .utf8)!
                    do {
                        // Serialize the json Data and cast it into Array of Dictionary
                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String: Any]]
                        // tran_type 필터
                        let duesArrSorted = jsonObject?.filter({ (dictionary) -> Bool in
                            dictionary["dues_type"] as? String != ""
                        })
                        self.dues_Data = duesArrSorted!
                        
                    } catch {
                        print(error)
                    }
                    
                    var dues_type_Arr:[Dictionary<String, Any>] = []
                    dues_type_Arr = self.dues_Data as! [Dictionary<String, Any>]
                    for dues_type_Add in dues_type_Arr {
                        self.generator = "\(dues_type_Add["dues_type"] ?? String.self)"
                        var d_type = self.generator
                        if d_type == "month" {
                            d_type = "월이용료"
                        } else if d_type == "year" {
                            d_type = "연이용료"
                        }
                        
                        self.dues_type.append(d_type)
                    }
                    print("dues_type")
                    print(self.dues_type)
                    
                    
                    var dues_amount_Arr:[Dictionary<String, Any>] = []
                    dues_amount_Arr = self.dues_Data as! [Dictionary<String, Any>]
                    for dues_amount_Add in dues_amount_Arr {
                        self.generator = "\(dues_amount_Add["dues_amount"] ?? String.self)"
                        let point = Int(self.generator)
                        let result = Int(self.generator)?.withComma
                        self.dues_amount_Sum.append(point!)
                        self.dues_amount.append(result! + " P")
                    }
                    print("dues_amount")
                    print(self.dues_amount)
                    
                    var dues_month_Arr:[Dictionary<String, Any>] = []
                    dues_month_Arr = self.dues_Data as! [Dictionary<String, Any>]
                    for dues_month_Add in dues_month_Arr {
                        self.generator = "\(dues_month_Add["dues_month"] ?? String.self)"
                        let d_month = self.generator
                        let year = d_month.prefix(4)
                        let month = d_month.suffix(2)
                        let d_month_total = year + "년 " + month + "월\n이용료"
                        self.dues_month.append(d_month_total)
                        
                    }
                    print("dues_month")
                    print(self.dues_month)
                    
                    
                    var ins_dt_Arr:[Dictionary<String, Any>] = []
                    ins_dt_Arr = self.dues_Data as! [Dictionary<String, Any>]
                    for ins_dt_Add in ins_dt_Arr {
                        self.generator = "\(ins_dt_Add["ins_dt"] ?? String.self)"
                        
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
                        self.ins_dt.append(generator_total1 + generator_total2)
                    }
                    
                    print("ins_dt")
                    print(self.ins_dt)
                    
                    if self.dues_amount.isEmpty {
                        self.feesPayHistoryStatusLabel?.text = "- 납부내역이 없습니다 -"
                    } else {
                        self.feesPayHistoryStatusLabel?.text = "- 납부내역 조회 완료 -"
                    }

                    self.reroad()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension FeesPayHistoryVC: CalendarPopUpDelegate {
    @objc func dateChaged(date: Date) {
        currentDate = date
    }
}

