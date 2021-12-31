import Foundation
import RxSwift

var lists = BehaviorSubject<[String]>(value: ["Hello", "fuck you"])

var result = lists
                .map{
                    $0.filter{$0=="Hello"}
                }
print(result)
