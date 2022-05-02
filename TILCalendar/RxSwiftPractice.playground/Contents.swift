import Foundation
import RxSwift

let disposeBag = DisposeBag()
var observable = Observable<Int>.of(1,2,3,4,5)

observable
    .subscribe { emitter in
        switch emitter {
        case .next(let value):
            print(value)
        case .error(let error):
            print("error occured: \(error)")
        case .completed:
            print("Completed")
        }
    }
    .disposed(by: disposeBag)
    

