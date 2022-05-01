//  TILMainViewController.swift

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

class TILMainViewController: UIViewController {
    
    var tilList = BehaviorRelay<[TIL]>(value: [])
    
    let tilViewModel = TILViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tilCalendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setDelegate()
        setCalendarAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tilList.accept(tilViewModel.allTIL())
        tilCalendar.reloadData()
    }
    
    private func setDelegate() {
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
        
        self.navigationController?.pushViewController(tableVC, animated: true)
        
        print("Clicked")
        tilCalendar.deselect(date)
    }
    
    // drawing event dots on calendar
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var events: [String] = []
        
        _ = tilList
            .asObservable()
            .subscribe(onNext:{
                $0.forEach {
                    events.append($0.createdDate.formatToString())
                }
            })
            .disposed(by: disposeBag)
        
        if events.contains(date.formatToString()) {
            return 1
        } else {
            return 0
        }
    }
}

//Appearance 코드들
extension TILMainViewController {
    func setNavigationBar() {
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.scarlet]
        self.navigationController?.navigationBar.tintColor = UIColor.scarlet
        
        //Title Text
        self.navigationItem.title = "TIL Calendar"
    }
    
    func setCalendarAppearance() {
        // not show other month day
        tilCalendar.placeholderType = .none
        
        //Locale Set
        tilCalendar.locale = Locale(identifier: "ko_KR")
        
        //Header Date Format
        tilCalendar.appearance.headerDateFormat = "YYYY년 M월"
        
        //Font Size
        tilCalendar.appearance.headerTitleFont = UIFont.preferredFont(forTextStyle: .title2)
        tilCalendar.appearance.weekdayFont = UIFont.preferredFont(forTextStyle: .headline)
        tilCalendar.appearance.titleFont = UIFont.preferredFont(forTextStyle: .headline)
        
        //Color
        tilCalendar.appearance.headerTitleColor = UIColor.blackColor
        tilCalendar.appearance.weekdayTextColor = UIColor.blackColor
        tilCalendar.appearance.titleTodayColor = UIColor.blackColor
        tilCalendar.appearance.todayColor = UIColor.brightGreen
        tilCalendar.appearance.titleDefaultColor = UIColor.blackColor
        tilCalendar.appearance.eventDefaultColor = UIColor.skyBlue
    }
}
