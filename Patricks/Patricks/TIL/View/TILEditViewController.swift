//
//  TILEditViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

class TILEditViewController: UIViewController {
    
    enum Mode {
        case create
        case edit
    }
    
    var til: TIL!
    var selectedSubjectId: Int!
    var selectedDate: Date!
    var mode: Mode!
    
    var tilViewModel: TILViewModel!
    var subjectViewModel: SubjectViewModel!
    var subjectObserver = BehaviorSubject<String>(value: "과목 선택")
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subjectSelectButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectSelectButton.contentHorizontalAlignment = .left
        
        if til == nil {
            mode = .create
        } else {
            mode = .edit
        }
        
        if mode == .edit {
            fillText(til)
        }
        
        _ = subjectObserver.bind(to: subjectSelectButton.rx.title())
        
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if (isThereChange()) {
            let alert = (mode == .edit)
            ? UIAlertController(title: "알림", message: "변경사항이 있습니다!", preferredStyle: .actionSheet)
            : UIAlertController(title: "알림", message: "작성 내용이 있습니다!", preferredStyle: .actionSheet)
            
            let defaultAction = UIAlertAction(title: "저장하지 않고 나가기", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel, handler: nil)
            
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        if subjectSelectButton.titleLabel?.text == "과목 선택" {
            let alert = UIAlertController(title: "", message: "과목을 선택해주세요!", preferredStyle: .alert)
            let action = UIAlertAction(title: "돌아가기", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(mode == .edit) {
            updateCurrentTil()
        }
        
        if(mode == .create) {
            saveCurrentTil()
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func subjectClicked(_ sender: Any) {
        guard let subjectVC = storyboard?.instantiateViewController(withIdentifier: "TILSubjectSelectViewController") as? TILSubjectSelectViewController else {return}
        
        subjectVC.modalPresentationStyle = .overCurrentContext
        self.present(subjectVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let parentVC = parent as? TILTableViewController else {return}
        parentVC.hidesBottomBarWhenPushed = false
    }
    
}

extension TILEditViewController {
    
    //fill data to textview / textfield
    func fillText(_ til: TIL) {
        
        subjectObserver.onNext(subjectViewModel.getSubjectNameById(til.subjectId))
        
        titleTextField.text = til.title
        contentTextView.text = til.content
        selectedSubjectId = til.subjectId
    }
    
    //check whether data is changed or not
    func isThereChange() -> Bool {
        if (mode == .edit) {
            if (titleTextField.text != til.title) || (subjectSelectButton.titleLabel?.text != subjectViewModel.getSubjectNameById(til.subjectId)) || (contentTextView.text != til.content) {
                return true
            }
        }
        else if (mode == .create) {
            if (titleTextField.text != "") ||
                (contentTextView.text != "" ||
                 (subjectSelectButton.titleLabel?.text != "과목 선택")) {
                return true
            }
        }
        return false
    }
    
    func updateCurrentTil() {
        til.title = titleTextField.text!
        til.content = contentTextView.text!
        til.subjectId = selectedSubjectId
        tilViewModel.updateTil(til)
    }
    
    func saveCurrentTil() {
        let newTIL: TIL = TIL(tilViewModel.tilCount+1, titleTextField.text!, contentTextView.text!, selectedDate, selectedSubjectId)
        
        tilViewModel.addTil(newTIL)
    }
    
}

extension UITextView {
    func addDoneButtonToKeyboard() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        toolBar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, doneButton]
        
        toolBar.items = items
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
