//
//  CardInfoVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 5..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import GameplayKit
import GestureRecognizerClosures
import QRCodeReader


class CardInfoVC: UIViewController,QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var cardInfo_DumLabel: UILabel!
    @IBOutlet var cardInfoView: UIView!
    struct MyStruct: Codable {
        let type: String
        let memberSrl: String
        let mallName: String
        let returnUrl: String
        let totalAmount: Int
        let orderNumber: Int
        let productName: String
    }
    
    //============ QR 코드 영역 ============//
    
//    @IBOutlet weak var previewView: QRCodeReaderView! {
//        didSet {
//            previewView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
//        }
//    }
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }

    // 스캔한 값
    @IBAction func scanInModalAction(_ sender: AnyObject) {

        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                //                print("Completion with result: \(result.value) of type \(result.metadataType)")

                let qrdata = String(result.value)
                let decoder = JSONDecoder()
                let myStruct = try! decoder.decode(MyStruct.self, from: qrdata.data(using: .utf8)!)
                
                
                
                Data_QRCode.shared.qrcode_type = myStruct.type
                Data_QRCode.shared.qrcode_mallName = myStruct.mallName
                Data_QRCode.shared.qrcode_shopSrl = myStruct.memberSrl
                Data_QRCode.shared.qrcode_orderNumber = "\(myStruct.orderNumber)"
                Data_QRCode.shared.qrcode_productName = myStruct.productName
                Data_QRCode.shared.qrcode_returnUrl = myStruct.returnUrl
                Data_QRCode.shared.qrcode_totalAmount = "\(myStruct.totalAmount)"
                
                print("큐알코드")
                
                self.checkShopDataLoad()
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    //    @IBAction func scanInPreviewAction(_ sender: Any) {
    //        guard checkScanPermissions(), !reader.isRunning else { return }
    //
    //        reader.didFindCode = { result in
    //            print("Completion with result: \(result.value) of type \(result.metadataType)")
    //        }
    //
    //        reader.startScanning()
    //    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true)
        // 큐알 코드 읽을때 코드내용 얼럿창으로 표시
//        { [weak self] in
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            self?.present(alert, animated: true, completion: nil)
//        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    //============ QR 코드 영역 ============//
    
    @IBOutlet weak var cardInfoDumPointTF: UITextField!
    @IBOutlet weak var cardInfoBarCodeView: UIImageView!
    @IBOutlet weak var cardInfoSlideMenuBtnOutlet: UIButton!
    

    
    @IBOutlet weak var cardInfoMyCashPoint: UILabel!
    @IBOutlet weak var cardInfoBannerImage: UIImageView!
    @IBOutlet weak var cardInfoMainImage: UIImageView!
    
    let ud = UserDefaults.standard
    let serviceUrl = UrlData()
    
    var filter:CIFilter!
    var accountHave = false
    let bannerImageArray:[UIImage] = [#imageLiteral(resourceName: "main_banner3"),#imageLiteral(resourceName: "main_banner4")]
//    let bannerImageArray:[String] = ["main_banner3","main_banner4"]

    
    // 앱 설정 불러오기 영역
    var version:String = ""
    var useNoti:String = ""
    var notiTitle:String = ""
    var notiContents:String = ""
    var notiImg:String = ""
    var notiLink:String = ""
    var imgUrl:String = ""
    var cardcheck = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Data_Default.shared.IndexPathNum = ""
//        cardInfoBannerImage.image = UIImage(named: "main_banner3")

        Data_Default.shared.device_WidthSize = "\(self.view.frame.size.width)"
        
        // 우 -> 좌 화면 밀면 뷰 이동
        cardInfoView.onSwipeLeft{ _ in
            if self.accountHave == false {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccount")
                
                self.navigationController?.pushViewController(nextVC!, animated: true)
            } else if self.accountHave == true {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccountHave")
                
                self.navigationController?.pushViewController(nextVC!, animated: true)
            }
        }

        
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.appDataLoad()
            ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
            ServerTrans_FeesPayDataLoad.shared.feesPayDataLoad()
            self.defaultSettings()
            self.barCodeGenerate()
            if Data_MemberInfo.shared.fcm_key != Data_Default.shared.new_FcmToken {
                ServerTrans_RegistFcmKey.shared.registFcmKeySend()
            }
            
        }
        

        
        // 바코드 이미지 터치 이벤트
        cardInfoBarCodeView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        cardInfoBarCodeView.addGestureRecognizer(tapRecognizer)
        
        // 메인 카드 이미지 터치 이벤트
        cardInfoMainImage.isUserInteractionEnabled = true
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(mainimageViewTapped))
        cardInfoMainImage.addGestureRecognizer(tapRecognizer2)
        
        // 배너 이미지 터치 이벤트
        cardInfoBannerImage.isUserInteractionEnabled = true
        let tapRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(bannerimageViewTapped))
        cardInfoBannerImage.addGestureRecognizer(tapRecognizer3)

        // 메인 컨트롤러의 참조  정보를 가져온다.
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle(_:)을 호출하도록 정의한다.
            self.cardInfoSlideMenuBtnOutlet.addTarget(revealVC, action: #selector(revealVC.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(revealVC.tapGestureRecognizer())
            // 뷰 탭하면 슬라이드 닫기
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        let str = cardInfoMyCashPoint.text!
        let cardInfoPointText:String = cardInfoMyCashPoint.text!
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: cardInfoPointText as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 18.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#696969FF")!, range: NSRange(location:(str.count - 1),length:1))
        cardInfoMyCashPoint.attributedText = myMutableString
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
    }
    
    
    // Can be refactored to an extension on UIImage
    func animate(imageView: UIImageView, images: [UIImage]) {

        imageView.animationImages = images
        imageView.animationDuration = 3.0
        imageView.animationRepeatCount = 100000
        imageView.startAnimating()
    }
    

    
    // 바코드 이미지 터치 이벤트
    @objc func imageViewTapped(imageView:UITapGestureRecognizer? = nil ) {

//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BarCodeZoomStoryID")
//        self.navigationController?.pushViewController(nextVC!, animated: true)
        
        
        cardInfoBannerImage.image = UIImage(named: "main_banner3")
        
    }
    
    
    // 메인 카드 이미지 터치 이벤트
    @objc func mainimageViewTapped(imageView:UITapGestureRecognizer? = nil ) {
        
        
//        if cardcheck == 0 {
//            cardcheck = 1
//            cardInfoMainImage.image = UIImage(named: "new_cardViewMain2")
//        } else {
//            cardcheck = 0
//            cardInfoMainImage.image = UIImage(named: "new_cardViewMain")
//        }

                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BarCodeZoomStoryID")
                self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    
    

    
    // 배너 이미지 터치 이벤트
    @objc func bannerimageViewTapped(imageView:UITapGestureRecognizer? = nil ) {
    
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewStoryID")
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
        // 외부 사파리로 실행
//        if let url = URL(string: "http://www.toptwotwo.com/") {0
//            UIApplication.shared.open(url, options: [:])
//        }
    }

    
    // 카드 정보 refresh 버튼
    @IBAction func cardInfoRecycleBtn(_ sender: Any) {
        ServerTrans_AssetDataLoad.shared.memberAssetDataLoad()
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.defaultSettings()
        }
    }
    
    // 로드시 기본 정보 셋팅
    func defaultSettings(){
        // 텍스트 필드 및 레이블 스타일 셋팅
        
        cardInfoMyCashPoint.isHidden = true

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: -50, height: self.cardInfoDumPointTF.frame.height))
        cardInfoDumPointTF.rightView = paddingView
        cardInfoDumPointTF.rightViewMode = UITextField.ViewMode.always
        cardInfoDumPointTF.isEnabled = false
        cardInfoDumPointTF.layer.cornerRadius = 10
        
        cardInfo_DumLabel.layer.masksToBounds = true
        cardInfo_DumLabel.layer.cornerRadius = 10
    
        
//        let member_user_name = Data_MemberInfo.shared.user_name
//        if member_user_name == "" {
//            cardInfoMyNameLabel?.text = ""
//        } else if member_user_name != "" {
//            cardInfoMyNameLabel?.text = member_user_name
//        }
        
//         가상계좌 번호 불러오기
        let member_acc_no = Data_MemberInfo.shared.acc_no

        if member_acc_no == "" {
            print("카드 없음")
            
        } else if member_acc_no != "" {
            print("카드 있음")
//            let lastFourLength = String(describing: member_acc_no.suffix(4))
            accountHave = true
//            cardInfoMyCardNumLabel?.text = "**********" + "\(lastFourLength)"
        }
        
        // 포인트 잔액 조회
        let member_cash_bal = Data_MemberAsset.shared.cash_bal
        
        if member_cash_bal == "" {
            cardInfoMyCashPoint?.text = ""
        } else if member_cash_bal != "" {
            
            cardInfoMyCashPoint?.text = (Int(member_cash_bal)?.withComma)! + " P"
        }
        
        // 덤 잔액 조회
        let member_dum_bal = Data_MemberAsset.shared.dum_bal
        
        if member_dum_bal == "" {
            cardInfoDumPointTF?.text = "0"
        } else {
            cardInfoDumPointTF?.text = (Int(member_dum_bal)?.withComma)! + "  "
        }
        
    }

    // 가상계좌 번호를 바코드로 변환
    func barCodeGenerate(){

        let member_acc_no = Data_MemberAsset.shared.acc_no
        if member_acc_no != "" {
            let text = member_acc_no
            let data = text.data(using: .ascii, allowLossyConversion: false)
            filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
            
            cardInfoBarCodeView.image = image
        }
        return
    }
    
    // 충전내역 조회 버튼
    @IBAction func goToChargeHistoryBtn(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_ChargeHistory")
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    // 나의 계좌 조회 버튼
    @IBAction func goToMyAccountBtn(_ sender: Any) {
        
        if accountHave == false {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccount")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        } else if accountHave == true {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SWReveal_MyAccountHave")
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
    }
    
    // 샵 배너 웹페이지 오픈 이벤트
//    @IBAction func goTodlxShopWebViewBtn(_ sender: Any) {
//        if let url = URL(string: "http://www.theokmall.com/") {
//            UIApplication.shared.open(url, options: [:])
//        }
//    }
    

    
    // 큐알 코드 결제시 구매하는 가맹점의 유효성 체크
    func checkShopDataLoad(){
        let member_srl = Data_MemberInfo.shared.member_srl
        let shop_srl = Data_QRCode.shared.qrcode_shopSrl
        /*
            member_srl     =   회원 고유 번호
            shop_srl       =   샵 고유 번호
        */
 
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/checkShop"
            let param: Parameters = [
                "member_srl": member_srl,
                "shop_srl": shop_srl
            ]
            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                if let jsonObject = response.result.value as? [String: Any] {
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodePayCheckStoryID")
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
                        self.displayMsg(title: "원페이", msg: "결제 정보를 다시 확인해 주시기 바랍니다.")
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }

    
    

    
    
    
    // 앱 설정 불러오기
    func appDataLoad(){
        let device_code = "004"
        do {
            let url = serviceUrl.realServiceUrl + "/onepay/rest/pgExe"
            let param: Parameters = [
                "device_code": device_code
            ]

            let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
            alamo.responseJSON() { response in
                
                if let jsonObject = response.result.value as? [String: Any] {
                    
                    if String(describing: (jsonObject["resultCode"]!)) == "1"{
                        self.version = jsonObject["version"] as! String
                        self.useNoti = jsonObject["useNoti"] as! String
                        self.notiTitle = jsonObject["notiTitle"] as! String
                        self.notiContents = jsonObject["notiContents"] as! String
                        self.notiImg = jsonObject["notiImg"] as! String
                        self.notiLink = jsonObject["notiLink"] as! String
                        
                        /*
                        print(self.version)
                        print(self.useNoti)
                        print(self.notiTitle)
                        print(self.notiContents)
                        print(self.notiImg)
                        print(self.notiLink)
                        */
                        
                        let newUpdateVersion = self.version.components(separatedBy: ["."]).joined()
                        let deviceAppVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)?.components(separatedBy: ["."]).joined()
                        
                        
                        guard let oldVer = Int(deviceAppVersion!) else { return }
                        guard let newVer = Int(newUpdateVersion) else { return }
                        
                        print("디바이스 버전 : " + "\(oldVer)")
                        print("서버 버전 : " + "\(newVer)")

                        
                        // 앱 버전 체크
                        if oldVer < newVer {
                            let alertTitle = "원페이"
                            let alertMessage = "새로운 버전이 업데이트 되었습니다.\n업데이트 후 사용 가능합니다."

                            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

                            let cancel = UIAlertAction(title: "취소", style: .destructive) { UIAlertAction in

                                exit(0)
                            }

                            let ok = UIAlertAction(title: "업데이트", style: .default) {
                                UIAlertAction in

                                let url = NSURL(string: "https://itunes.apple.com/kr/app/toppay/id1446048698?mt=8")!

                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url as URL)
                                } else {
                                    UIApplication.shared.openURL(url as URL)
                                }
                            }

                            alert.addAction(cancel)
                            alert.addAction(ok)

                            self.present(alert, animated: false)
                        }
                        
                        
                        
                        // 공지사항 표시 여부
//                        if self.useNoti == "N"{
//                            return
//                        } else if self.useNoti == "Y" {
//                            guard let notiCheck = self.ud.string(forKey: "notiCheck") else { return }
//                            if notiCheck == "false" {
//                                return
//                            }
//                            self.imgUrl = self.notiImg
//                            let url = URL(string: self.imgUrl)
//                            let data = try? Data(contentsOf: url!)
//                            let imageData = data
//
//                            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 250 , height: 120)))
//                            imageView.image = UIImage(data: imageData!)
//
//                            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.isOpaque, 0.0)
//                            defer { UIGraphicsEndImageContext() }
//                            let context = UIGraphicsGetCurrentContext()
//                            imageView.layer.render(in: context!)
//                            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//
//                            let alertMessage = UIAlertController(title: self.notiTitle, message: self.notiContents, preferredStyle: .alert)
//
//                            let action = UIAlertAction(title: "", style: .default, handler: nil)
//                            action.setValue(finalImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
//                            alertMessage .addAction(action)
//                            let action1 = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
//
//                                self.ud.set("false", forKey: "notiCheck")
//                            }
//                            alertMessage.addAction(action1)
//                            self.present(alertMessage, animated: true, completion: nil)
//                        }
//
//                    } else if String(describing: (jsonObject["resultCode"]!)) == "0" {
//
                    }
                    print("resultCode = \(jsonObject["resultCode"]!)")
                    print("resultMessage = \(jsonObject["resultMessage"]!)")
                }
            }
        }
    }
    
    @IBAction func btn_Json(_ sender: Any) {
        
        var dict = [String:String]()
        dict = ["data": "{\"type\":\"mobilePay\",\"memberSrl\":\"1181\",\"mallName\":\"\\ud0d1\\uc6d4\\ub4dc\\ubab0\",\"returnUrl\":\"http:\\/\\/www.toptwotwo.com\\/shop_goods\\/jumun_app_exec_card.php?solution_type=shop&tmp_app_idx=2748073&tmp_jumun_idx=2748073\",\"totalAmount\":10930,\"orderNumber\":2748073,\"productName\":\"\\ub514\\uc2a4\\ud06c\\uc774\\uc988+\\uc6d0\\ubc18\\ub358\\uc9c0..\"}"]
        
        let json = JSON(dict)
        
        
        let data:String = json["data"].stringValue
        let dicts = data.toJSON() as? [String:AnyObject] // can be any type here
        
        let type = dicts!["type"]!
        let memberSrl = dicts!["memberSrl"]!
        let mallName = dicts!["mallName"]!
        let returnUrl = dicts!["returnUrl"]!
        let totalAmount = dicts!["totalAmount"]!
        let orderNumber = dicts!["orderNumber"]!
        let productName = dicts!["productName"]!
        
        print("✅ 쇼핑몰 결제 정보 = \(String(describing: data))")
        print("type = \(type)")
        print("memberSrl = \(memberSrl)")
        print("mallName = \(mallName)")
        print("returnUrl = \(returnUrl)")
        print("totalAmount = \(totalAmount)")
        print("orderNumber = \(orderNumber)")
        print("productName = \(productName)")
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
