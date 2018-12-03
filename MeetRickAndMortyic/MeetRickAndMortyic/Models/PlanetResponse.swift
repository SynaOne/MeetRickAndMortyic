//
//  PlanetResponse.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 02/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlanetResponse {

    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: Int

    init(json: JSON) throws {

        guard
            let id = json["id"].int,
            let name = json["name"].string,
            let type = json["type"].string,
            let dimension = json["dimension"].string,
            let residents = json["residents"].array
            else {
                throw ResponseError.InvalidJSON
        }

        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension

        self.residents = residents.count
    }
}
