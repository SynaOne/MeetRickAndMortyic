//
//  AlamofireExtension.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 01/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import SwiftyJSON
import Alamofire

extension DataRequest {

    @discardableResult
    func responseSwiftyJSON(completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Self {

        return responseJSON { response in
            completionHandler(response.map(JSON.init))
        }
    }
}
