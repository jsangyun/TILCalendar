//  DateExtension.swift

import Foundation

extension Date {
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}
