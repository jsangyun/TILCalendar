//
//  TILEditViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/01/09.
//

import UIKit

class TILEditViewController: UIViewController {
    
    var til: TIL!
    var subjectName: String!
    
    var tilViewModel = TILViewModel()
    var subjectViewModel = SubjectViewModel()
    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subjectSelectButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillText(til)
        
        /*
        //view move upward when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        contentTextView.addDoneButtonToKeyboard()
         */
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if (isThereDifference()) {
            let alert = UIAlertController(title: "알림", message: "변경사항이 있습니다!", preferredStyle: .alert)
            
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
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func subjectClicked(_ sender: Any) {
    }
    
    /*
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
//        contentTextView.frame.origin.y -= keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
//        contentTextView.frame.origin.y += keyboardSize.height
    }
    */
}

extension TILEditViewController {
    
    //fill data to textview / textfield
    func fillText(_ til: TIL) {
        subjectName = subjectViewModel.getSubjectNameById(til.subjectId)
        
        titleTextField.text = til.title
        subjectSelectButton.setTitle(subjectName, for: .normal)
        subjectSelectButton.contentHorizontalAlignment = .left
        contentTextView.text = til.content
    }
    
    //check whether data is changed or not
    func isThereDifference() -> Bool {
        if (titleTextField.text != til.title) || (subjectSelectButton.titleLabel?.text != subjectName) || (contentTextView.text != til.content) {
            return true
        }
        return false
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
