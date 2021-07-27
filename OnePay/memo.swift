//
//  memo.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 11..
//  Copyright © 2017년 유하늘. All rights reserved.
//

/*

 상단 status bar 배경색 : 4BBDD4
 사이드바 메뉴 버튼(짙은 남색) :  1F8395
 납부내역 버튼 색 (황색) : EEB975
 캘린더 파란색 : 14BDD8
 캘린더 짙은 회색 : 424242
 
 // 리뉴얼
 
 메인 색 : AB0033 cranberry
 
 
 ===================================================================
 // 문자열 사이에 특수 문자 제거
 var str = "Hello~!@@@, Swift Zedd"
 
 str.components(separatedBy: ["~","!","@",",","S","w","i","f","t"]).joined()Hello Zedd
 
 ===================================================================
 
 // 숫자 세자리 마다 콤마 찍기
 let numberFormatter = NumberFormatter()
 numberFormatter.numberStyle = .decimal
 let point = Int(myPoint!)
 let result = numberFormatter.string(from: NSNumber(value:point!))!
 
 ===================================================================
 
 // 데이터 리프레쉬
 
 var refresher: UIRefreshControl!
 
 override func viewDidLoad()
 {
 super.viewDidLoad()
 
 refresher = UIRefreshControl()
 }
 
 func reroad(){
 
 for i in 1...1000
 {
 array.append(i)
 }
 
 tableView.reloadData()
 refresher.endRefreshing()
 
 }
 
 ===================================================================
 
 // 특정 문자 제거 하기
 var input = "Eat pok\\u00e9.\n"
 
 // removes newline
 input = String(input.characters.map {
 $0 == "\n" ? " " : $0
 })

 ===================================================================
 
 
 // 사파리로 웹페이지 오픈
 
 if let url = URL(string: "http://www.dlxshop.com/") {
 UIApplication.shared.open(url, options: [:])
 }
 
 ===================================================================

 
 // 마지막 자리 가져오기
 let lastFourLength = String(describing: member_acc_no!.suffix(4))
 // 앞 4자리 가져오기
let lastFourLength = String(describing: member_acc_no!.preffix(4))
 
 ===================================================================
 
 // 시간 딜레이

 let when = DispatchTime.now() + 0.3
 DispatchQueue.main.asyncAfter(deadline: when) {
 }
 
===================================================================
 
 extension Array {
 mutating func shuffle() {
 for i in 0..<(count - 1) {
 let j = Int(arc4random_uniform(UInt32(count - i))) + i
 guard i != j else { continue}
 self.swapAt(i, j)
 }
 }
 }
 
 // 문자열 섞기
 let selectedWord = "1234567890"
 var a = Array(selectedWord)
 a.shuffle()
 let apprv_no = String(a)
 print(apprv_no)
===================================================================
LUExpandableTableView
QuickTableViewController
 
 ❗️ 웹 페이지 에서 보노카드로 결제 누르면 앱 실행 시키기
    - 웹 인텐트 결제
 
 ⚠️ 드롭박스 뷰 에서 팝뷰 안되는 현상
 
 ⚠️ 푸쉬메시지 - 알림 받으면 뷰 정보 수정
 
 ✅ 보노 가맹점 신청 마무리

 ✅ 보노카드 이용료 결제 하기 전 송금 & 상품 결제 안되게 하기
    - 큐알 , 송금 적용
 
 ✅ 가상계좌 등록 하고 카드 정보에서 바코드 표시
    - 자산조회 정보로 대치
 
 ✅ 결제 하고 나서 자산 정보 리로드
    - 모든 결제 비밀번호 성공후 자산조회 시작
 
 ✅ 큐알 코드 랜덤 유니크 번호 생성
 
 ✅ 웹뷰 띄우지 말고 사파리로 띄우기
 
 ✅  이메일 화면 올리기
 
 ✅  휴대폰번호 키패드
 
 ✅  백그라운드 이미지
 
 
 // 추가 사항
 ✅ 지사명 -> 지점명
 ✅ 실계좌 빼기 회원가입, 회원수정
 ✅ 내가추천한사람
 ✅ 충전내역 항목추가
 ✅ 덤 보이는 것 빼기
 ✅ 회원정보수정 19830608
 ✅ 가맹점 리스트 api 로 받아오기
 ✅ 약관수정하기
 ✅ 거래내역에 충전내역 보여주기
 */

// 작업 해야 할 일 : 스마트콘 나의 쿠폰 상태 체크


// 🅿️🅿️🅿️🅿️🅿️🅿️🅿️🅿️🅿️ 탑 페이 🅿️🅿️🅿️🅿️🅿️🅿️🅿️🅿️🅿️
/*
⚠️ 컬러코드
 #A89C8D 회색
 #C39B45 밝은 갈색
 #332003 진한갈색
 
 
 
 
 */
