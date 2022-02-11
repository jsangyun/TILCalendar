//
//  TILSubjectSelectViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/02/10.
//

import UIKit
import RxSwift

class TILSubjectSelectViewController: UIViewController {
    
    var subjectViewModel = AppMainViewController.subjectViewModel
    var allSubjects: [Subject] = []
    let disposeBag = DisposeBag()
    
    var selectedSubjectId: Int = 0

    @IBOutlet weak var subjectPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectPickerView.delegate = self
        subjectPickerView.dataSource = self
        
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        guard let prevVC = self.presentingViewController as? TILEditViewController else {return}
        prevVC.selectedSubjectId = self.selectedSubjectId
        prevVC.subjectObserver.onNext(subjectViewModel.getSubjectNameById(self.selectedSubjectId))
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

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
            .dispose()
        return allSubjects[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubjectId = row
    }
}
