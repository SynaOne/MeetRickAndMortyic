//
//  Character.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 01/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class Character {

    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String?
    let gender: CharacterGender
    let originLocation: Location
    let currentLocation: Location
    let imageUrl: String
    var image: Data?
    let episode: [String]
    let url: String
    let created: Date

    init(json: JSON) throws {

        guard
            let id = json["id"].int,
            let name = json["name"].string,
            let status = json["status"].string.flatMap({ CharacterStatus(rawValue: $0) }),
            let species = json["species"].string,
            let type = json["type"].string,
            let gender = json["gender"].string.flatMap({ CharacterGender(rawValue: $0) }),
            let originLocation = try? Location(json: json["origin"]),
            let currentLocation = try? Location(json: json["location"]),
            let imageUrl = json["image"].string,
            let episodeArray = json["episode"].array,
            let url = json["url"].string
            else {
                throw ResponseError.InvalidJSON
        }

        self.id = id
        self.name = name
        self.status = status
        self.type = type
        self.species = species
        self.gender = gender
        self.originLocation = originLocation
        self.currentLocation = currentLocation
        self.imageUrl = imageUrl
        self.episode = episodeArray.compactMap({ $0.string })
        self.url = url
        self.created = Date()

        loadImage()
    }

    func loadImage() {

        Alamofire.request(imageUrl).responseData(completionHandler: { [weak self] dataResponse in

            guard let strongSelf = self else { return }

            switch dataResponse.result {
            case .failure:
                // On ne fait rien
                break
            case .success(let data):
                strongSelf.image = data

                NotificationCenter.default.post(name: .imageLoaded,
                                                object: nil,
                                                userInfo: ["characterId": strongSelf.id])
            }
        })
    }

}

enum CharacterStatus: String {
    case Alive = "Alive"
    case Dead = "Dead"
    case Unknown = "unknown"
}

enum CharacterGender: String {
    case Female = "Female"
    case Genderless = "Genderless"
    case Male = "Male"
    case Unknown = "unknown"
}

class Location {

    let name: String
    let url: String

    init(json: JSON) throws {

        guard
            let name = json["name"].string,
            let url = json["url"].string
            else {
                throw ResponseError.InvalidJSON
        }

        self.name = name
        self.url = url
    }
}
