//
//  PhoneAuthVC.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 1..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit
import Toaster

class PhoneAuthVC: UIViewController,UIWebViewDelegate,UIAlertViewDelegate {
    
    @IBOutlet weak var authWebView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var phoneAuth = false
    override func viewDidLoad() {
        super.viewDidLoad()

        authWebView.delegate = self
        authWebView.loadRequest(URLRequest(url: NSURL(string:"http://api.bonocard.net:8080/danal/Ready.jsp")! as URL))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func webViewBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Webview Delegate
    /**
     * 웹페이지 리퀘스트 요청 시작
     */
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {

        let requestedURL: URL? = request.url
        let receivedLink: String? = requestedURL?.absoluteString
        print("Should Request::: \(String(describing: receivedLink))")
        /**
         * 휴대폰 인증 완료 후 결과값 전달 받기
         */
        
        let result: String? = receivedLink?.removingPercentEncoding
        
        print("====== 폰 인증 =====")
        print("requestedURL : \(String(describing: requestedURL))")
        print("receivedLink : \(String(describing: receivedLink))")
        print("result : \(String(describing: result))")
        print("====== 폰 인증 =====")
        
        
        if result! == "http://api.bonocard.net:8080/danal/Success.jsp"{
            let title = "원페이"
            let message = "본인인증 성공."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) {
                UIAlertAction in
                Data_SignUp.shared.signUp_PhoneAuthResult = "success"
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else if result! == "https://wauth.teledit.com/Danal/WebAuth/Web/Error.php"{
            let title = "원페이"
            let message = "본인인증 실패."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) {
                UIAlertAction in

                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        return true
    }
    /**
     * 웹페이지 로딩 시작
     */
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("****************************************")
        print("web vie load")
        print("****************************************")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    /**
     * 웹페이지 로딩 종료
     */
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("****************************************")
        print("web vie finish")
        print("****************************************")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        self.dismiss(animated: true, completion: nil)
    }
    /**
     * 웹페이지 로딩 중 오류
     */
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("Load Fail - 내용: \(error.localizedDescription)")
        // NSURLErrorDomain error -999 무시하기.
        if (error as NSError?)?.code == NSURLErrorCancelled {
            return
        }
    }
}


//extension PhoneAuthVC:UIWebViewDelegate {
//    func webViewDidStartLoad(_ webView: UIWebView) {
//
//        activityView.startAnimating()
//    }
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//
//        activityView.isHidden = true
//    }
//}
