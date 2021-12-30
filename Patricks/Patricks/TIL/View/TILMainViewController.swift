//
//  TILMainViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/11/19.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

class TILMainViewController: UIViewController {
    
    var viewModel = TILViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tilCalendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setDelegate()
        setCalendarAppearance()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = viewModel.allTIL
            .take(1)
            .subscribe(onNext: { tils in
                for til in tils {
                    print(til.createdDate)
                }
            })
            .disposed(by: disposeBag)
        
        tilCalendar.reloadData()
    }
    
    func setNavigationBar() {
        //Larget Title Color
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.96, green: 0.87, blue: 0.66, alpha: 1)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
        
        //Title Text
        self.navigationItem.title = "TIL Calendar"
    }
    
    func setDelegate() {
        tilCalendar.dataSource = self
        tilCalendar.delegate = self
    }
    
    func setCalendarAppearance() {
        //Locale Set
        tilCalendar.locale = Locale(identifier: "ko_KR")
        
        //Header Date Format
        tilCalendar.appearance.headerDateFormat = "YYYY월 M월"
        
        //Font Size
        tilCalendar.appearance.headerTitleFont = UIFont.preferredFont(forTextStyle: .title2)
        tilCalendar.appearance.weekdayFont = UIFont.preferredFont(forTextStyle: .headline)
        tilCalendar.appearance.titleFont = UIFont.preferredFont(forTextStyle: .subheadline)
        
        //Color
        tilCalendar.appearance.headerTitleColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
        tilCalendar.appearance.weekdayTextColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
        tilCalendar.appearance.selectionColor = UIColor(red: 0.59, green: 0.16, blue: 0.17, alpha: 0.8)
        tilCalendar.appearance.todayColor = UIColor(red: 0.96, green: 0.87, blue: 0.66, alpha: 1)
        tilCalendar.appearance.eventDefaultColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
    
    }

}

extension TILMainViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // Date Select Event
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TILDetailViewController") as? TILDetailViewController else { return }
        
        if viewModel.searchTIL(APIService.formatDateToString(date)) {
            print("YES!")
        } else {
            print("NO ㅠㅠ")
        }
        
        detailVC.selectedDate = date
        detailVC.viewModel = self.viewModel
        self.navigationController?.pushViewController(detailVC, animated: true)
            
    }
    
    // 날짜 밑 점 찍기
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var events: [String] = []
        
        _ = viewModel.allTIL
            .take(1)
            .subscribe(onNext:{ tils in
                for til in tils {
                    events.append(til.createdDate)
                }
            })
        
        if events.contains(APIService.formatDateToString(date)) {
            return 1
        } else {
            return 0
        }
    }
}
