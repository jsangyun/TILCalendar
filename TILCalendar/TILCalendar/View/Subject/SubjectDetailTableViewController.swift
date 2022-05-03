//  SubjectDetailTableViewController.swift

import UIKit
import RxSwift
import RxCocoa
import Lottie

class SubjectDetailTableViewController: UIViewController {
    
    var subjectId: String!
    var subjectName: String!
    var tilList = BehaviorRelay<[TIL]>(value: [])
    
    @IBOutlet weak var tableView: UITableView!
    
    let tilViewModel = TILViewModel()
    let subjectViewModel = SubjectViewModel()

    let disposeBag = DisposeBag()
    let emptyView = AnimationView(name: "empty-animation")
    let cellIdentifier = "SubjectDetailTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        bindTableView()
        bindEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tilList.accept(tilViewModel.getTILBySubject(subjectId: subjectId))
    }
    
    private func bindEmptyView() {
        view.addSubview(emptyView)
        emptyView.setUp()
        emptyView.bind(relay: tilList, disposeBag: disposeBag)
    }
    
    private func setNavigationBar() {
        subjectName = subjectViewModel.getSubjectName(id: subjectId)
        self.navigationItem.title = subjectName
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bindTableView() {
        
        // data binding
        _ = tilList
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: SubjectDetailTableViewCell.self)) { (index, item, cell) in
                
                cell.bind(title: item.title, date: item.createdDate)
                
            }
            .disposed(by: disposeBag)
        
        // select event binding
        _ =  Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(TIL.self))
            .subscribe(onNext: { [weak self] (indexPath, til) in
                
                guard let tilDetailVC = UIStoryboard(name: "TIL", bundle: nil).instantiateViewController(withIdentifier: "TILDetailViewController") as? TILDetailViewController else {return}
                
                tilDetailVC.selectedId = til.id
                
                self?.navigationController?.pushViewController(tilDetailVC, animated: true)
                
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }

}
