//
//  Extensions.swift
//  chat
//
//  Created by Гидаят Джанаева on 02.07.2024.
//

import UIKit


//MARK: - String

extension String {
   static func localize(_ text: String.LocalizationValue) -> String {
        String(localized: text)
  }
}

extension String {
    static let state = "state"
}

extension String{
    static let users = "Users"
    static let conversation = "Conversation"
    static let messages = "Messages"
}

extension String {
    func truncate(to limit: Int, ellipsis: Bool = true) -> String {
        if count > limit {
            let truncated = String(prefix(limit)).trimmingCharacters(in: .whitespacesAndNewlines)
            return ellipsis ? truncated + "\u{2026}" :truncated
        } else {
            return self
        }
    }
}

//MARK: - UIView

extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}

//MARK: - Date

extension Date {
    func isDifferentDay(than date: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)
        return components1 != components2
    }
}
