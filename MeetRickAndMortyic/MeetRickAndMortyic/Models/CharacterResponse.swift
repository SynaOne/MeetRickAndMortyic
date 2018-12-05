//
//  CharacterResponse.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 01/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import SwiftyJSON

class CharacterResponse {

    var info: CharactersInfo
    var results: [Character]

    var asMoreCharactersToLoad: Bool {
        return info.count > results.count
    }

    init(json: JSON) throws {

        guard
            let info = try? CharactersInfo(json: json["info"]),
            let resultsArray = json["results"].array
            else {
                throw ResponseError.InvalidJSON
        }

        let characters = resultsArray.compactMap { try? Character.init(json: $0) }

        self.info = info
        self.results = characters

    }

    public func setResults(newResults: [Character],
                           keepOldResults: Bool = true) {

        self.results = (results + newResults).removeDuplicates()

    }

    public func setNewInfo(infos: CharactersInfo) {

        self.info = infos
    }
}
