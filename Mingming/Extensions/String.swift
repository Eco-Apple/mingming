//
//  String.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/15/25.
//

import Foundation

extension String {
    func toTags() -> [String] {
        let regex = try! NSRegularExpression(pattern: "#\\w+", options: [])
        let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        
        let tagsArray = matches.map { match in
            String(self[Range(match.range, in: self)!])
        }
        
        return tagsArray
    }
}
