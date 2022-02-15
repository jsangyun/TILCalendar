//
//  TILSubjectSelectViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/02/10.
//

import UIKit
import RxSwift
import RxCocoa

class TILSubjectSelectViewController: UIViewController {
    
    var subjectViewModel = AppMainViewController.subjectViewModel
    let disposeBag = DisposeBag()
    
    var selectedSubjectId: Int!

    @IBOutlet weak var subjectPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectPickerView.delegate = nil
        subjectPickerView.dataSource = nil
        
        _ = subjectViewModel.allSubjects
            .bind(to: subjectPickerView.rx.itemTitles) { _, item in
                self.selectedSubjectId = item.id
                return item.name
        }
        
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        if let id = selectedSubjectId,
           let prevVC = self.presentingViewController as? TILEditViewController {
            prevVC.selectedSubjectId = id
            prevVC.subjectObserver.onNext(subjectViewModel.getSubjectNameById(id))
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let addSubjectVC = UIStoryboard(name: "Subject", bundle: nil).instantiateViewController(withIdentifier: "SubjectCreateViewController") as? SubjectCreateViewController else {return}
        
        addSubjectVC.subjectViewModel = subjectViewModel
        
        self.present(addSubjectVC, animated: true, completion: nil)
    }
}
