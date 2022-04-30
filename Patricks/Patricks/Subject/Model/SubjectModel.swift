//  SubjectModel.swift

import Foundation

struct Subject: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id : Int
    var name: String
    
    init(_ id: Int, _ name: String) {
        self.id = id
        self.name = name
    }
    
}
