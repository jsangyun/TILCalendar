//  StringExtension.swift

import Foundation

extension String {
    func formatToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        guard let date = formatter.date(from: self) else {
            print("Reformat Error: Returned Today Date")
            return Date()
        }
        return date
    }
}
