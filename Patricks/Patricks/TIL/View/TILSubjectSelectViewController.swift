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
    var allSubjects: [Subject] = []
    let disposeBag = DisposeBag()
    
    var selectedSubjectId: Int!

    @IBOutlet weak var subjectPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectPickerView.delegate = nil
        subjectPickerView.dataSource = nil
        
        _ = subjectViewModel.allSubjects
            .map{$0.sorted(by: {$0.id < $1.id})}
            .bind(to: subjectPickerView.rx.itemTitles) { _, item in
                self.selectedSubjectId = 0
                return item.name
        }
        
        _ = subjectPickerView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.selectedSubjectId = $0.row
            })
            .disposed(by: disposeBag)
        
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

/*
extension TILSubjectSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectViewModel.subjectCount
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        _ = subjectViewModel.allSubjects
            .subscribe(onNext: { [weak self] in
                self?.allSubjects = $0
            })
            .disposed(by: disposeBag)
        
        return allSubjects[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubjectId = row
    }
 
}
 */
