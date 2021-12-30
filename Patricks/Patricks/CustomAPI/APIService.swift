//
//  APIService.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/07.
//

import Foundation
import Firebase

class APIService {

    static func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    static func formateStringToDate(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        guard let date = formatter.date(from: string) else {
            print("Reformat Error: Returned Today Date")
            return Date()
        }
        return date
    }
}
