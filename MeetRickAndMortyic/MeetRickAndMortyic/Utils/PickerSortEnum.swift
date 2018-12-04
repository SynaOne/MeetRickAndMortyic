//
//  PickerSortEnum.swift
//  MeetRickAndMortyic
//
//  Created by Jean-Marie CLAPIE on 04/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation

enum PickerSortEnum: String, CaseIterable {

    case nameAlpha = "Name order"
    case nameAlphaInverse = "Name inverse order"
    case speciesAlpha = "Species order"
    case speciesAlphaInverse = "Species inverse order"
    case statusAlpha = "Status order"
    case statusAlphaInverse = "Status inverse order"
    case genderAlpha = "Gender order"
    case genderAlphaInverse = "Gender inverse order"
    case noSort = "No sort"
}
