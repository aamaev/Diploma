//
//  localized.swift
//  Diploma
//
//  Created by Артём Амаев on 4.04.24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
  
    func localized(_ args: [CVarArg]) -> String {
        return String(format: localized, args)
    }
  
    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, args)
    }
}
