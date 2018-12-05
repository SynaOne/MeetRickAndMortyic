//
//  ArrayExtension.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 04/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    @discardableResult
    mutating func remove(_ element: Element) -> Bool {

        if let index = self.index(of: element) {
            remove(at: index)
            return true
        } else {
            return false
        }
    }

    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
