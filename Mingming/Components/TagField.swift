//
//  TagField.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/16/25.
//

import SwiftUI

struct TagField: View {
    @Binding var text: String
    var tagsLimit: Int
    
    var body: some View {
        TextField("#DailyHabits", text: $text)
            .customize(label: "Tags")
            .frame(width: 280)
            .onChange(of: text) { oldValue, newValue in
                guard !(newValue.count == tagsLimit && newValue.last == " ") else {
                    text = oldValue
                    return
                }
                guard newValue != " " else {
                    text = oldValue
                    return
                }
                guard newValue.count <= tagsLimit else {
                    text = oldValue
                    return
                }
                
                if newValue.count >= 2 {
                    let secondToLastIndex = newValue.index(newValue.endIndex, offsetBy: -2)
                    if newValue.last == "#" && newValue[secondToLastIndex] != " " {
                        text = oldValue
                        return
                    }
                    
                    if newValue.last == " " && newValue[secondToLastIndex] == "#" {
                        text = oldValue
                        return
                    }
                    
                    if newValue.last == " " && newValue[secondToLastIndex] == " " {
                        text = String(newValue[..<secondToLastIndex])
                        return
                    }
                    
                    if newValue.last != "#" && newValue[secondToLastIndex] == " " {
                        if let last = newValue.last {
                            text = "\(String(newValue[..<secondToLastIndex])) #\(last.uppercased())"
                            return
                        }
                    }
                    
                    guard newValue.hasPrefix(oldValue) else {
                        let modifiedSentence = newValue.split(separator: " ")
                            .map { word in
                                if word.starts(with: "#") {
                                    let firstLetter = word.dropFirst().prefix(1).uppercased()
                                    let restOfWord = word.dropFirst(2)
                                    return "#\(firstLetter)\(restOfWord)"
                                } else {
                                    return "#\(word)"
                                }
                            }
                            .joined(separator: " ")
                        
                        text = modifiedSentence
                        return
                    }
                    
                    let startIndex = oldValue.endIndex
                    let addedText = String(newValue[startIndex...])
                    
                    if addedText.last == " " {
                        text = oldValue + addedText.replacingOccurrences(of: " ", with: " #")
                    } else {
                        let modifiedSentence = newValue.split(separator: " ")
                            .map { word in
                                if word.starts(with: "#") {
                                    let firstLetter = word.dropFirst().prefix(1).uppercased()
                                    let restOfWord = word.dropFirst(2)
                                    return "#\(firstLetter)\(restOfWord)"
                                } else {
                                    return String(word)
                                }
                            }
                            .joined(separator: " ")
                        
                        text = modifiedSentence
                    }
                    
                } else {
                    if newValue != "#" && !newValue.isEmpty {
                        text = "#" + newValue.uppercased()
                    }
                }
            }
        
    }
}

#Preview {
    TagField(text: .constant(""), tagsLimit: 32)
}
