//  TILTableViewController.swift

import UIKit
import RxSwift
import RxCocoa
import Lottie

class TILTableViewController: UIViewController {

    @IBOutlet weak var tilTableView: UITableView!
    
    let tilViewModel = TILViewModel()
    let subjectViewModel = SubjectViewModel()
    
    var tilList = BehaviorRelay<[TIL]>(value: [])
    
    var selectedDate: Date!
    var selectedTilId: Int? = nil
    
    var disposeBag = DisposeBag()
    
    let cellIdentifier = "TILTableViewCell"
    let emptyView = AnimationView(name: "empty-animation")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        bindEmptyView()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tilList.accept(tilViewModel.getTILByDate(date: selectedDate))
    }
    
    private func bindEmptyView() {
        view.addSubview(emptyView)
        emptyView.setUp()
        emptyView.bind(relay: tilList, disposeBag: disposeBag)
    }
    
    private func bindTableView() {
        
        // data binding
        _ = tilList.bind(to: tilTableView.rx.items(cellIdentifier: cellIdentifier, cellType: TILTableViewCell.self)) { [weak self] (index, til, cell) in
            
            cell.bind(title: til.title, subjectName: (self?.subjectViewModel.subjectName(of: til.subjectId))!)
            
        }
        .disposed(by: disposeBag)
        
        // select event
        Observable.zip(tilTableView.rx.modelSelected(TIL.self), tilTableView.rx.itemSelected)
            .subscribe(onNext: { [weak self] (til, indexPath) in
                
                guard let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: "TILDetailViewController") as? TILDetailViewController else {return}
                
                
                detailVC.selectedId = til.id
                self?.navigationController?.pushViewController(detailVC, animated: true)
                
                self?.tilTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        // delete event
        _ = tilTableView.rx.modelDeleted(TIL.self)
            .subscribe(onNext: { [weak self] deletedTil in
                
                self?.tilViewModel.deleteTil(id: deletedTil.id)
                
                if let date = self?.selectedDate,
                   let newList = self?.tilViewModel.getTILByDate(date: date) {
                    self?.tilList.accept(newList)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    @objc func createButtonClicked() {
        guard let createVC = storyboard?.instantiateViewController(withIdentifier: "TILEditViewController") as? TILEditViewController else {return}
        
        createVC.modalPresentationStyle = .fullScreen
        createVC.selectedDate = self.selectedDate
        
        self.present(createVC, animated: true, completion: nil)
    }
}

// Appearance code
extension TILTableViewController {
    func setNavigationBar() {
        self.navigationItem.title = selectedDate.formatToString()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.scarlet,
            .font: UIFont.preferredFont(forTextStyle: .title3)
        ]
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonClicked))
        
        self.navigationItem.rightBarButtonItem = createButton
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
