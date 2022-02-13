//
//  SubjectDetailTableViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/01/13.
//

import UIKit
import RxSwift

class SubjectDetailTableViewController: UITableViewController {
    
    var subjectId: Int!
    var subjectName: String!
    var tils: [TIL]!
    
    var tilViewModel = AppMainViewController.tilViewModel
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptyView = EmptyNoticeView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        emptyView.center.x = self.view.center.x
        emptyView.center.y = self.view.center.y * 0.77
        tableView.isScrollEnabled = false
        view.addSubview(emptyView)
        
        _ = tilViewModel.allTIL
            .map{$0.filter{$0.subjectId == self.subjectId}}
            .subscribe(onNext: { [weak self] in
                self?.tils = $0.sorted(by: {$0.createdDate > $1.createdDate})
                self?.tableView.reloadData()
                
                if $0.isEmpty {
                    emptyView.isHidden = false
                } else {
                    emptyView.isHidden = true
                    self?.tableView.isScrollEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        self.navigationItem.title = subjectName
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tils.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectDetailTableViewCell") as! SubjectDetailTableViewCell
        let item = tils[indexPath.row]
        
        cell.tilTitleLabel.text = item.title
        cell.tilDateLabel.text = item.createdDate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tilDetailVC = UIStoryboard(name: "TIL", bundle: nil).instantiateViewController(withIdentifier: "TILDetailViewController") as? TILDetailViewController else {return}
        
        tilDetailVC.tilId = tils[indexPath.row].id
        tilDetailVC.tilViewModel = tilViewModel
        tilDetailVC.subjectViewModel = AppMainViewController.subjectViewModel
        
        self.navigationController?.pushViewController(tilDetailVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tilViewModel.deleteTil(tils[indexPath.row].id)
        }
    }

}
