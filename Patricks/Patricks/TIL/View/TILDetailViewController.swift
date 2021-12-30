//
//  TILDetailViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/06.
//

import UIKit
import RxSwift
import RxCocoa

class TILDetailViewController: UIViewController {

    var selectedDate: Date!
    var viewModel: TILViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    func setNavigationBar() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
        
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.title = APIService.formatDateToString(selectedDate)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1),
            .font: UIFont.preferredFont(forTextStyle: .title3)
        ]
    }
    
    @objc
    func deleteButtonPressed() {
        print("Delete Button Pressed!")
        self.navigationController?.popViewController(animated: true)
    }
}
