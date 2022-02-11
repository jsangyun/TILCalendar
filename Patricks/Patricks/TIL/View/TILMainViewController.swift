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
    
    var tilViewModel = AppMainViewController.tilViewModel
    var subjectViewModel = AppMainViewController.subjectViewModel
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tilCalendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setDelegate()
        setCalendarAppearance()
    }
    
    func setDelegate() {
        tilCalendar.dataSource = self
        tilCalendar.delegate = self
    }
}

//FSCalendar
extension TILMainViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // calendar click event
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        guard let tableVC = self.storyboard?.instantiateViewController(withIdentifier: "TILTableViewController") as? TILTableViewController else { return }
        
        tableVC.selectedDate = date
        tableVC.tilViewModel = self.tilViewModel
        tableVC.subjectViewModel = self.subjectViewModel
        
        self.navigationController?.pushViewController(tableVC, animated: true)
    }
    
    // drawing event dots on calendar
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var events: [String] = []
        
        _ = tilViewModel.allTIL
            .subscribe(onNext:{
                $0.forEach {
                    events.append($0.createdDate)
                }
            })
            .disposed(by: disposeBag)
        
        if events.contains(APIService.formatDateToString(date)) {
            return 1
        } else {
            return 0
        }
    }
}

//Appearance 코드들
extension TILMainViewController {
    func setNavigationBar() {
        //Larget Title Color
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
        
        //Title Text
        self.navigationItem.title = "TIL Calendar"
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
        tilCalendar.appearance.selectionColor = UIColor(red: 0.96, green: 0.87, blue: 0.66, alpha: 1)
        tilCalendar.appearance.todayColor = UIColor(red: 0.59, green: 0.16, blue: 0.17, alpha: 0.8)
        tilCalendar.appearance.eventDefaultColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
    }
}
