//
//  CharacterCell.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 02/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterStatus: UILabel!
    @IBOutlet weak var characterSpecies: UILabel!
    @IBOutlet weak var characterGender: UILabel!
    @IBOutlet weak var erreurAvatar: UILabel!

    var character: Character?

    func setup(character: Character) {

        self.character = character

        if character.status == .Unknown {
            characterStatus.isHidden = true
        } else {
            characterStatus.isHidden = false
            characterStatus.text = character.status.rawValue
        }

        if character.gender == .Unknown {
            characterGender.isHidden = true
        } else {
            characterGender.isHidden = false
            characterGender.text = character.gender.rawValue
        }

        characterName.text = character.name
        characterSpecies.text = character.species

        if let image = character.image {
            characterImage.image = UIImage(data: image, scale: 1)
            if characterImage.image == nil {
                characterImage.isHidden = true
                erreurAvatar.isHidden = false
            } else {
                characterImage.isHidden = false
                erreurAvatar.isHidden = true
            }
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        } else {
            characterImage.isHidden = true
            erreurAvatar.isHidden = true
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        }
    }

}
