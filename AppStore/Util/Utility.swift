//
//  Utility.swift
//  AppStore
//
//  Created by 김주희 on 9/10/24.
//

import Foundation


func formattedRatingCount(_ count: Int) -> String {
    if count >= 10_000 {
        let formatted = Double(count) / 10_000
        return String(format: "%.1f만", formatted)
    } else {
        return "\(count)"
    }
}

func getPreferredLanguage(_ languages: [String]) -> String {
    let preferredLanguage = Locale.preferredLanguages.first?.prefix(2).uppercased() ?? ""
    return languages.first(where: { $0 == preferredLanguage }) ?? languages.first ?? ""
}

func getLangCount(_ languages: [String]) -> String {
    return languages.count - 1 == 0 ? "" : "+ \(languages.count - 1)개 언어"
}

func numberOfNewLines(text: String) -> Int {
    return text.components(separatedBy: "\n").count - 1
}

func truncatedText(text: String) -> String {
    let components = text.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: false)
    
    if components.count > 2 {
        let thirdNewlineIndex = components[0...1].joined(separator: "\n").count
        return String(text.prefix(thirdNewlineIndex))
    } else {
        return text
    }
}
