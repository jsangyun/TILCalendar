//
//  TILViewModel.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/03.
//

import Foundation
import RxSwift

class TILViewModel {
    
    var allTIL = BehaviorSubject<[TIL]>(value: [])
    
    init() {
        allTIL.onNext([
            TIL("Content 1", "2021월 12월 8일", [0]),
            TIL("Content 2", "2021월 12월 7일", [0,1]),
            TIL("Content 3", "2021월 12월 6일", [1]),
        ])
    }
    
    func searchTIL(_ dateString: String) -> Bool {
        var result: Bool = false
        
//        allTIL
//            .map { }
//            .dispose()
        
        return result
    }
    
    func deleteTIL(_ dateString: String) {
        var newList: [TIL] = []
        
        _ = allTIL
            .take(1)
            .subscribe(onNext: { tils in
                for til in tils {
                    if dateString != til.createdDate {
                        print("Added")
                        newList.append(til)
                    }
                }
            })
        
        allTIL
            .onNext(newList)
    }
    
//    func getSubjectTIL(subjectId: Int) -> [TIL] {
//        allTIL
//            .filter({ $0.e})
//    }
}
