//
//  CharactersInfo.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 01/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import SwiftyJSON

class CharactersInfo {

    let count: Int
    let pages: Int
    let next: String?
    let prev: String?

    init(json: JSON) throws {

        guard
            let count = json["count"].int,
            let pages = json["pages"].int,
            let next = json["next"].string,
            let prev = json["prev"].string
            else {
                throw ResponseError.InvalidJSON
        }

        self.count = count
        self.pages = pages
        self.next = next == "" ? nil : next
        self.prev = prev == "" ? nil : prev
    }
}
