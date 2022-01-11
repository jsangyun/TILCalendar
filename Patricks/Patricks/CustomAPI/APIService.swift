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
    
    
    static func load<T: Codable>(_ filename: String) -> T {
        
        let data: Data
        let filePath = NSHomeDirectory() + "/Documents/\(filename)"
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try data = Data(contentsOf: fileUrl)
        } catch {
            /* when there is no json file at directory, create one */
            print("Creating empty \(filename) to \(filePath)")
            
            let encoder = JSONEncoder()
            let emptyJson: [T] = []
            
            if let temp = try? encoder.encode(emptyJson) {
                try! temp.write(to: fileUrl)
            }
            
            try! data = Data(contentsOf: fileUrl)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self).")
        }
    }
    
}
