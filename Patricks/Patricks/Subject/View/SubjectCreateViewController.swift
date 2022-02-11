//
//  SubjectCreateViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/02/09.
//

import UIKit

class SubjectCreateViewController: UIViewController {

    @IBOutlet weak var subjectNameTextField: UITextField!
    
    var subjectViewModel: SubjectViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subjectNameTextField.becomeFirstResponder()
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
            subjectViewModel.addSubject(subjectNameTextField.text!)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
