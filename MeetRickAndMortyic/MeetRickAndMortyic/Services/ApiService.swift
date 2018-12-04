//
//  ApiService.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 01/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol ApiServiceProtocol {
    func getCharacters(urlToCall: String?,
                       completion: @escaping (Result<CharacterResponse>) -> Void)
    func getPlanetInfos(url: String,
                        completion: @escaping (Result<PlanetResponse>) -> Void)
    func loadImage(imageUrl: String,
                   completion: @escaping (Result<Data>) -> Void)
}

class ApiService: ApiServiceProtocol {

    static let sharedApiService = ApiService()

    func getCharacters(urlToCall: String? = nil,
                       completion: @escaping (Result<CharacterResponse>) -> Void) {

        let url = urlToCall ?? "https://rickandmortyapi.com/api/character/"

        Alamofire.request(url)
            .validate()
            .responseSwiftyJSON { response in

                switch response.result {
                case .success(let value):

                    if let characterResponse = try? CharacterResponse(json: value) {
                        completion(Result<CharacterResponse>.success(characterResponse))
                    } else {
                        completion(Result<CharacterResponse>.failure(ResponseError.InvalidJSON))
                    }
                case .failure(let error):
                    completion(Result<CharacterResponse>.failure(error))
                }
        }
    }

    func getPlanetInfos(url: String,
                        completion: @escaping (Result<PlanetResponse>) -> Void) {

        Alamofire.request(url)
            .validate()
            .responseSwiftyJSON { response in

                switch response.result {
                case .success(let value):
                    if let planetResponse = try? PlanetResponse(json: value) {
                        completion(Result<PlanetResponse>.success(planetResponse))
                    } else {
                        completion(Result<PlanetResponse>.failure(ResponseError.InvalidJSON))
                    }
                case .failure(let error):
                    completion(Result<PlanetResponse>.failure(error))
                }
        }
    }

    func loadImage(imageUrl: String,
                   completion: @escaping (Result<Data>) -> Void) {

        Alamofire.request(imageUrl).responseData(completionHandler: { dataResponse in

            switch dataResponse.result {
            case .failure:
                completion(Result<Data>.failure(ResponseError.InvalidImage))
                break
            case .success(let data):
                if data.count == 0 {
                    completion(Result<Data>.failure(ResponseError.InvalidImage))
                } else {
                    completion(Result<Data>.success(data))
                }
            }
        })
    }
}
