//
//  APIService.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/07.
//

import Foundation

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
    
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            try data = Data(contentsOf: url)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle.")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self).")
        }
    }
}
