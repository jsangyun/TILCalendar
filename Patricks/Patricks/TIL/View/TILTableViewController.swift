//
//  TILTableViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/06.
//

import UIKit
import RxSwift
import RxCocoa

class TILTableViewController: UITableViewController {

    @IBOutlet weak var tilTableView: UITableView!
    
    var selectedDate: Date!
    var selectedTilId: Int? = nil
    
    var tilViewModel: TILViewModel!
    var subjectViewModel: SubjectViewModel!
    
    var disposeBag = DisposeBag()
    
    var thisDayTIL: [TIL] = []
    let cellIdentifier = "TILTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        let emptyView = EmptyNoticeView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        emptyView.center.x = self.view.center.x
        emptyView.center.y = self.view.center.y * 0.77
        view.addSubview(emptyView)
        
        _ = tilViewModel.allTIL
            .observe(on: MainScheduler.instance)
            .map{
                $0.filter{$0.createdDate == self.selectedDate.formatToString()}
            }
            .subscribe(onNext: { [weak self] tils in
                self?.thisDayTIL = tils
                self?.tilTableView.reloadData()
                
                if (!tils.isEmpty) {
                    emptyView.isHidden = true
                    self?.tilTableView.isScrollEnabled = true
                } else {
                    emptyView.isHidden = false
                    self?.tableView.isScrollEnabled = false
                }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func createButtonClicked() {
        guard let createVC = storyboard?.instantiateViewController(withIdentifier: "TILEditViewController") as? TILEditViewController else {return}
        
        createVC.modalPresentationStyle = .overFullScreen
        createVC.selectedDate = self.selectedDate
        createVC.tilViewModel = self.tilViewModel
        createVC.subjectViewModel = self.subjectViewModel
        
        self.present(createVC, animated: true, completion: nil)
    }
}

//TableView 코드
extension TILTableViewController {
    
    //row select event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTilId = thisDayTIL[indexPath.row].id
        
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "TILDetailViewController") as? TILDetailViewController {
            
            detailVC.tilId = selectedTilId
            detailVC.tilViewModel = self.tilViewModel
            detailVC.subjectViewModel = self.subjectViewModel
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    //number of row per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisDayTIL.count
    }
    
    //drawing cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tilTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TILTableViewCell
        
        let data = thisDayTIL[indexPath.row]
        
        cell.tilTitleLabel.text = data.title
        cell.subjectNameLabel.text = subjectViewModel.getSubjectNameById(data.subjectId)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 스와이프 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tilViewModel.deleteTil(thisDayTIL[indexPath.row].id)
        }
    }
}


// Appearance code
extension TILTableViewController {
    func setNavigationBar() {
//        let rightButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
        
//        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.title = selectedDate.formatToString()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1),
            .font: UIFont.preferredFont(forTextStyle: .title3)
        ]
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonClicked))
        
        self.navigationItem.rightBarButtonItem = createButton
    }
}
