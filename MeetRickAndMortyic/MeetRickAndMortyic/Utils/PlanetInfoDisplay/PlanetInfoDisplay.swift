//
//  PlanetInfoDisplay.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 02/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PlanetInfoDisplay: UIView {

    // MARK: - IBOutlet
    @IBOutlet weak var timeBasedLabel: UILabel!
    @IBOutlet weak var infosView: UIView!
    @IBOutlet weak var planetName: UILabel!
    @IBOutlet weak var planetType: UILabel!
    @IBOutlet weak var planetDimension: UILabel!
    @IBOutlet weak var planetNumberOfResidents: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Variables
    var contentView: UIView!

    // MARK: - Xib Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetup()
    }

    // MARK: - Public func
    
    func setPlanetInfo(isOrigin: Bool,
                       planet: Location) {

        timeBasedLabel.text = "\(isOrigin ? "Origin" : "Current") location:"

        let apiService = ApiService()

        apiService.getPlanetInfos(url: planet.url) { [weak self] planetResponse in

            guard let strongSelf = self else { return }

            if let planetInfo = planetResponse.value {

                strongSelf.planetName.text = "Name: \(planetInfo.name)"
                strongSelf.planetType.text = "Type: \(planetInfo.type)"
                strongSelf.planetDimension.text = "Dimension: \(planetInfo.dimension)"
                strongSelf.planetNumberOfResidents.text = "Number of residents: \(planetInfo.residents)"
            } else {

                strongSelf.planetName.text = "Name: \(planet.name)"
                strongSelf.planetType.text = "Impossible de charger les autres informations pour le moment"
                strongSelf.planetDimension.text = ""
                strongSelf.planetNumberOfResidents.text = ""
            }

            strongSelf.infosView.isHidden = false
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.activityIndicator.isHidden = true
        }
    }

    // MARK: - Private func

    private func xibSetup() {

        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                        UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView)
    }

    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PlanetInfoDisplay", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return view
    }
}
