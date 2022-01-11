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
    var tilCount: Int = 0
    
    init() {
        
        var data: [TIL] = APIService.load("til.json")
        
        allTIL
            .onNext(data)
        
        tilCount = data.count
    }
    
    //해당 날짜의 TIL 목록 가져오기
    func getTILByDate(_ date: Date) -> [TIL] {
        var result: [TIL] = []
        
        _ = allTIL
            .map{
                $0.filter {$0.createdDate == APIService.formatDateToString(date)}
            }
            .take(1)
            .subscribe(onNext:{
                result = $0
            })
        
        return result
    }
    
    func savePresentData() {
        
    }
    
    func updateTil(_ til: TIL) {
        _ = allTIL
            .map {$0.filter{$0.id != til.id}}
            .take(1)
            .subscribe(onNext: {
                $0.forEach{print($0.title)}
                let newData: [TIL] = $0 + [til]
                newData.forEach{print($0.title)}
                APIService.save("til.json", newData)
                self.allTIL.onNext(newData)
            })
            .dispose()
    }

}
