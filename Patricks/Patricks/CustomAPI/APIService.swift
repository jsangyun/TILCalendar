//  APIService.swift

import Foundation

class APIService {
    
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
    
    static func save<T: Codable>(_ filename: String, _ data: [T]) {
        let saveData: Data
        let encoder = JSONEncoder()
        let filePath = NSHomeDirectory() + "/Documents/\(filename)"
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try saveData = encoder.encode(data)
        } catch {
            fatalError("Failed Encoding \(type(of: data))")
        }
        
        do {
            try saveData.write(to: fileUrl)
        } catch {
            fatalError("Failed to write to \(filename)")
        }
    }
}
