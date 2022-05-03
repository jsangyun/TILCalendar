//  SubjectCreateViewController.swift

import UIKit
import RxSwift

class SubjectCreateViewController: UIViewController {

    @IBOutlet weak var subjectNameTextField: UITextField!
    
    let subjectViewModel = SubjectViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subjectNameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let parentVC = self.presentingViewController as? TILSubjectSelectViewController {
            parentVC.subjectList.accept(subjectViewModel.allSubject())
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if subjectNameTextField.text == "" {
            let alert = UIAlertController(title: "", message: "과목 이름을 입력해주세요!", preferredStyle: .alert)
            let action = UIAlertAction(title: "돌아가기", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            subjectViewModel.saveNewSubject(name: subjectNameTextField.text!)
            dismiss(animated: true, completion: nil)
        }
    }
}
