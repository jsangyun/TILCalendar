//
//  TILTableViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/06.
//

import UIKit
import RxSwift
import RxCocoa

class TILTableViewController: UITableViewController {

    @IBOutlet weak var tilTableView: UITableView!
    
    var selectedDate: Date!
    var selectedTilId: Int? = nil
    
    var tilViewModel: TILViewModel!
    var subjectViewModel: SubjectViewModel!
    
    var disposeBag = DisposeBag()
    
    var thisDayTIL: [TIL] = []
    let cellIdentifier = "TILTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        _ = tilViewModel.allTIL
            .observe(on: MainScheduler.instance)
            .map{
                $0.filter{$0.createdDate == APIService.formatDateToString(self.selectedDate)}
            }
            .subscribe(onNext: { [weak self] tils in
                self?.thisDayTIL = tils
                self?.tilTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        if (thisDayTIL.isEmpty) {
            addEmptyNoticeView()
        }
    }
    
    @objc func createButtonClicked() {
        guard let createVC = storyboard?.instantiateViewController(withIdentifier: "TILEditViewController") as? TILEditViewController else {return}
        
        createVC.modalPresentationStyle = .overCurrentContext
        self.present(createVC, animated: true, completion: nil)
    }
}

extension TILTableViewController {
    
    //row select event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTilId = thisDayTIL[indexPath.row].id
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "TILDetailViewController") as? TILDetailViewController {
            
            detailVC.tilId = selectedTilId
            detailVC.tilViewModel = self.tilViewModel
            detailVC.subjectViewModel = self.subjectViewModel
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    //number of row per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisDayTIL.count
    }
    
    //drawing cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tilTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TILTableViewCell
        
        let data = thisDayTIL[indexPath.row]
        
        cell.tilTitleLabel.text = data.title
        cell.subjectNameLabel.text = subjectViewModel.getSubjectNameById(data.subjectId)
        
        return cell
    }
}


// Appearance code
extension TILTableViewController {
    func setNavigationBar() {
//        let rightButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
        
//        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.title = APIService.formatDateToString(selectedDate)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.58, green: 0.67, blue: 0.45, alpha: 1),
            .font: UIFont.preferredFont(forTextStyle: .title3)
        ]
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonClicked))
        
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    func addEmptyNoticeView() {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        let image = UIImageView(image: UIImage(named: "empty"))
        image.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        image.center.x = emptyView.center.x
        image.center.y = emptyView.center.y
        
        let message = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        message.text = "비어있어요!"
        message.font = UIFont(name: "Menlo-Regular", size: 20)
        message.textColor = UIColor.black.withAlphaComponent(0.85)
        message.sizeToFit()
        message.center.x = emptyView.center.x * 1.025
        message.center.y = emptyView.center.y * 1.85
        
        emptyView.addSubview(image)
        emptyView.addSubview(message)
        emptyView.center.x = self.view.center.x
        emptyView.center.y = self.view.center.y * 0.7
        self.view.addSubview(emptyView)
    }
}
