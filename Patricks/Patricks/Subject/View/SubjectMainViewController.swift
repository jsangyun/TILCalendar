//
//  SubjectMainViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/08.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectMainViewController: UIViewController {

    var viewModel = SubjectViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var subjectTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        _ = viewModel.allSubjects
            .bind(to: subjectTableView.rx.items(cellIdentifier: "SubjectTableViewCell", cellType: SubjectTableViewCell.self)) { index, item, cell in
                cell.subjectNameLabel.text = item.name
            }
    }
    
    func setNavigationBar() {
        let titleColor = UIColor(red: 0.96, green: 0.87, blue: 0.66, alpha: 1)
        let tintColor = UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1)
        
        //Larget Title Color
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: titleColor]
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: titleColor]
        self.navigationController?.navigationBar.tintColor = tintColor
    }
    
}
