//  SubjectModel.swift

import Foundation

struct Subject: Codable {
    
    var id : String
    var name: String
    
    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
}
