//
//  CharacterDetailsVC.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 02/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailsVC: UIViewController {

    // MARK: - IBOulet
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterStatus: UILabel!
    @IBOutlet weak var characterSpecies: UILabel!
    @IBOutlet weak var characterGender: UILabel!
    @IBOutlet weak var characterOriginLocation: PlanetInfoDisplay!
    @IBOutlet weak var characterCurrentLocation: PlanetInfoDisplay!
    @IBOutlet weak var characterEpisode: UILabel!
    @IBOutlet weak var erreurAvatar: UILabel!

    // MARK: - Variables
    var character: Character!

    // MARK: - VC Lifecycle
    override func viewDidLoad() {

        super.viewDidLoad()

        if let image = character.image {
            characterImage.image = UIImage(data: image, scale: 1)

            if characterImage.image == nil {
                characterImage.isHidden = true
                erreurAvatar.isHidden = false
            } else {
                characterImage.isHidden = false
                erreurAvatar.isHidden = true
            }
        }

        characterStatus.text = "Status: \(character.status)"
        characterSpecies.text = "Species: \(character.species)"
        characterGender.text = "Gender: \(character.gender)"

        let nombreEpisodes = character.episode.count
        characterEpisode.text = "Appears in \(nombreEpisodes) episode\(nombreEpisodes > 1 ? "s" : "")"

        characterOriginLocation.setPlanetInfo(isOrigin: true,
                                              planet: character!.originLocation)
        characterCurrentLocation.setPlanetInfo(isOrigin: false,
                                               planet: character!.currentLocation)
    }
}
