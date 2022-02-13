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
        
        let data: [TIL] = APIService.load("til.json")
        
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
    
    func addTil(_ til: TIL) {
        _ = allTIL
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { prev in
                let newData = prev + [til]
                APIService.save("til.json", newData)
                self.allTIL.onNext(newData)
            })
        
        tilCount += 1
    }
    
    func updateTil(_ til: TIL) {
        
        _ = allTIL
            .map {$0.filter{$0.id != til.id}}
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                let newData: [TIL] = $0 + [til]
                APIService.save("til.json", newData)
                self.allTIL.onNext(newData)
            })
    }
    
    func deleteTil(_ tilId: Int) {
        tilCount -= 1
        
        _ = allTIL
            .map {$0.filter{$0.id != tilId}}
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                APIService.save("til.json", $0)
                self.allTIL.onNext($0)
            })
    }
    
    func getTILBySubjectId(_ subjectId: Int) -> [TIL] {
        var tils: [TIL] = []
        
        _ = allTIL
            .map{$0.filter{$0.subjectId == subjectId}}
            .take(1)
            .subscribe(onNext: {
                tils = $0.sorted(by: {$0.createdDate > $1.createdDate})
            })
            
        return tils
    }
    
    func deleteTilBySubjectId( _ subjectId: Int) {
        
        _ = allTIL
            .take(1)
            .map{$0.filter{$0.subjectId != subjectId}}
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                APIService.save("til.json", $0)
                self.allTIL.onNext($0)
            })
    }

}
