//
//  SubjectMainTableViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/02/09.
//

import UIKit
import RxSwift

class SubjectMainViewController: UIViewController {
    
    var subjectViewModel = AppMainViewController.subjectViewModel
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    var allSubjects: [Subject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setNavigationBar()
        
        let emptyView = EmptyNoticeView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        emptyView.center.x = self.view.center.x
        emptyView.center.y = self.view.center.y * 0.95
        view.addSubview(emptyView)
        
        createButton.layer.cornerRadius = 30
        
        _ = subjectViewModel.allSubjects
            .subscribe(onNext: { [weak self] subjects in
                self?.allSubjects = subjects.sorted(by: {$0.id < $1.id})
                self?.tableView.reloadData()
                
                if !subjects.isEmpty {
                    emptyView.isHidden = true
                    self?.tableView.isScrollEnabled = true
                } else {
                    emptyView.isHidden = false
                    self?.tableView.isScrollEnabled = false
                }
            })
    }
    
}

extension SubjectMainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSubjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = allSubjects[indexPath.row]
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "SubjectMainTableViewCell") as! SubjectTableViewCell
        
        cell.subjectNameLabel.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "SubjectDetailTableViewController") as? SubjectDetailTableViewController else {return}
        
        let item = allSubjects[indexPath.row]
        
        detailVC.subjectId = item.id
        detailVC.subjectName = item.name
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let alert = UIAlertController(title: "경고!", message: "삭제하실 과목의 TIL들이 모두 삭제됩니다!", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
                print(indexPath.row)
                self.subjectViewModel.deleteSubject(indexPath.row)
                AppMainViewController.tilViewModel.deleteTilBySubjectId(indexPath.row)
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

extension SubjectMainViewController {
    func setNavigationBar() {
        let titleColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
        let tintColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
        
        //Larget Title Color
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: titleColor]
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: titleColor]
        self.navigationController?.navigationBar.tintColor = tintColor
        
    }
    
    @IBAction func createButtonClicked() {
        
        guard let createVC = storyboard?.instantiateViewController(withIdentifier: "SubjectCreateViewController") as? SubjectCreateViewController else {return}
        
        createVC.modalPresentationStyle = .overCurrentContext
        createVC.subjectViewModel = self.subjectViewModel
        
        self.present(createVC, animated: true, completion: nil)
    }
}
