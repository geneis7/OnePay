//
//  WebViewVC.swift
//  TopPay
//
//  Created by 유하늘 on 2019/07/15.
//  Copyright © 2019 유하늘. All rights reserved.
//

import UIKit
import SwiftyJSON

class WebViewVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var topPay_WebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        topPay_WebView.delegate = self
        
        topPay_WebView.loadRequest(URLRequest(url: NSURL(string:"http://www.toptwotwo.com/")! as URL))
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let requestedURL: URL? = request.url
        let receivedLink: String? = requestedURL?.absoluteString
        let yourTargetUrl = URL(string:receivedLink!)!
        
        var dict = [String:String]()
        let components = URLComponents(url: yourTargetUrl, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                dict[item.name] = item.value!
            }
        }
        
        let dicstring = String(describing: dict)
        let jsonData = dicstring.data(using: .utf8)!
        
        if let nsstr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
            let str = String(nsstr)
            // Print raw string
            print(str)
            
            do {
                let dic = try JSONSerialization.jsonObject(
                    with: str.data(using: String.Encoding.utf8)!,
                    options:JSONSerialization.ReadingOptions.mutableContainers)
                    as! NSDictionary
                
                // Print dictionary
                print(dic)
                
                if let ipAddress = dic["type"] {
                    // Print value
                    print("&&&&&&&")
                    print(ipAddress)
                }
                
                if let ipAddress2 = dic["type\\"] {
                    // Print value
                    print("&&&&&&&")
                    print(ipAddress2)
                }
            } catch {
                print("error occured")
            }

        }
        

        let json = JSON(dict)
        
        
        let data = json["data"]
        let type = json["data"][0]
        let memberSrl = json["data"][0].arrayValue.map {$0["memberSrl"].stringValue}
        let mallName = json["data"].arrayValue.map {$0["mallName"].stringValue}
        let returnUrl = json["returnUrl"]
        let totalAmount = json["totalAmount"]
        let orderNumber = json["orderNumber"]
        let productName = json["productName"]
        

        
        print("@@@@@@@@@@@@@@@@@@@@@@@@@")
        print(dict)
        print("data = \(String(describing: data))")
        print("type = \(String(describing: type))")
        print("memberSrl = \(String(describing: memberSrl))")
        print("mallName = \(String(describing: mallName))")
        print("returnUrl = \(String(describing: returnUrl))")
        print("totalAmount = \(String(describing: totalAmount))")
        print("orderNumber = \(String(describing: orderNumber))")
        print("productName = \(String(describing: productName))")
        
        
        


//        let result: String? = receivedLink?.removingPercentEncoding
        
//        print("====== 웹 뷰 통신 =====")
//        print("requestedURL : \(String(describing: requestedURL))")
//        print("receivedLink : \(String(describing: receivedLink))")
//        print("result : \(String(describing: result))")
//        print("=====================")
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("웹뷰 로드 시작")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("웹뷰 로드 종료")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("웹뷰 로드 실패")
    }

    @IBAction func btn_WebView_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
