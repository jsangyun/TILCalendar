//
//  TILDetailViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/06.
//

import UIKit
import RxSwift
import RxCocoa
//import RxDataSources

class TILTableViewController: UIViewController {

    @IBOutlet weak var TILTableView: UITableView!
    
    var selectedDate: Date!
    var tilViewModel = TILViewModel()
    var subjectViewModel = SubjectViewModel()
    var disposeBag = DisposeBag()
    var tilList: [TIL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
//        tilList = tilViewModel.getTILByDate(selectedDate)
        _ = tilViewModel.allTIL
            .map{
                $0.filter{$0.createdDate == APIService.formatDateToString(self.selectedDate)}
            }
            .bind(to: TILTableView.rx.items(cellIdentifier: "TILTableViewCell", cellType: TILTableViewCell.self)) { index, item, cell in
                
                cell.tilTitleLabel.text = item.title
                cell.subjectNameLabel.text = self.subjectViewModel.getSubjectNameById(item.subjectId)
                
            }
            .disposed(by: disposeBag)
    }
    
    /*
    @objc
    func deleteButtonPressed() {
        print("Delete Button Pressed!")
        self.navigationController?.popViewController(animated: true)
    }
    */
}


//TILDetailView Appearance 코드
extension TILTableViewController {
    func setNavigationBar() {
//        let rightButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
        
//        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.title = APIService.formatDateToString(selectedDate)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1),
            .font: UIFont.preferredFont(forTextStyle: .title3)
        ]
    }
}
