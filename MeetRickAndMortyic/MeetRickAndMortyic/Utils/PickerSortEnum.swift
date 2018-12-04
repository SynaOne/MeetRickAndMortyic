//
//  PickerSortEnum.swift
//  MeetRickAndMortyic
//
//  Created by Jean-Marie CLAPIE on 04/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation

enum PickerSortEnum: String, CaseIterable {

    case nameAlpha = "Name alphabetical order"
    case nameAlphaInverse = "Name inverse alphabetical order"
    case speciesAlpha = "Species alphabetical order"
    case speciesAlphaInverse = "Species inverse alphabetical order"
    case statusAlpha = "Status alphabetical order"
    case statusAlphaInverse = "Status inverse alphabetical order"
    case genderAlpha = "Gender alphabetical order"
    case genderAlphaInverse = "Gender inverse alphabetical order"
    case noSort = "Return"
}
