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
        
        createButton.layer.cornerRadius = 30
        
        _ = subjectViewModel.allSubjects
            .subscribe(onNext: { [weak self] subjects in
                self?.allSubjects = subjects
                self?.tableView.reloadData()
            })
        
        if allSubjects.isEmpty {
            addEmptyNoticeView()
            tableView.isScrollEnabled = false
        }
        
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
        self.tableView.deselectRow(at: indexPath, animated: true)
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
        
    }
    
    func addEmptyNoticeView() {
        let emptyView = EmptyNoticeView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        emptyView.center.x = self.view.center.x
        emptyView.center.y = self.view.center.y * 0.95
        self.view.addSubview(emptyView)
    }
}
