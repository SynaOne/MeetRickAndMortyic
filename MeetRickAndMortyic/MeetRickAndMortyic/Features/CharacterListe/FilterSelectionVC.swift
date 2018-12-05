//
//  FilterSelectionVC.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 04/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

class FilterSelectionVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var statusStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var speciesStackView: UIStackView!
    @IBOutlet weak var speciesStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var genderStackViewHeight: NSLayoutConstraint!

    // MARK: - Variables
    var characterListe: [Character]!
    var filtersState = [(String, FiltersEnum, UISwitch)]()
    var currentApplicatedFilters: [(String, FiltersEnum)]!

    private var genders: [CharacterGender] {
        return characterListe.compactMap { $0.gender }.removeDuplicates()
    }
    private var species: [String] {
        return characterListe.compactMap { $0.species }.removeDuplicates()
    }
    private var status: [CharacterStatus] {
        return characterListe.compactMap { $0.status }.removeDuplicates()
    }

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        createFilters(filterType: .species,
                      filters: species.sorted())
        createFilters(filterType: .gender,
                      filters: genders.compactMap {$0.rawValue }.sorted())
        createFilters(filterType: .status,
                      filters: status.compactMap { $0.rawValue }.sorted())
    }

    // MARK: - IBAction

    @IBAction func exitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {

        if let presentingViewController = presentingViewController,
            presentingViewController.children.indices.contains(0),
            let characterListeVC = presentingViewController.children[0] as? CharacterListeVC {

            characterListeVC.currentApplicatedFilters.removeAll()
        }

        dismiss(animated: true)
    }

    @IBAction func doneButtonClicked(_ sender: UIButton) {

        if let presentingViewController = presentingViewController,
            presentingViewController.children.indices.contains(0),
            let characterListeVC = presentingViewController.children[0] as? CharacterListeVC {

            characterListeVC.currentApplicatedFilters.removeAll()
            for filter in filtersState where filter.2.isOn {
                characterListeVC.currentApplicatedFilters.append((filter.0, filter.1))
            }
        }

        dismiss(animated: true)
    }


    // MARK: - Private funcs

    private func createFilters(filterType: FiltersEnum,
                               filters: [String]) {

        let stackView: UIStackView
        let stackViewHeight: NSLayoutConstraint

        switch filterType {
        case .gender:
            stackView = genderStackView
            stackViewHeight = genderStackViewHeight
        case .species:
            stackView = speciesStackView
            stackViewHeight = speciesStackViewHeight
        case .status:
            stackView = statusStackView
            stackViewHeight = statusStackViewHeight
        }

        for filter in filters {

            let stackViewVertical = UIStackView()
            stackViewVertical.distribution = .fill
            stackViewVertical.axis = .horizontal
            stackViewVertical.spacing = 10

            let filterSwitch = UISwitch()
            stackViewVertical.addArrangedSubview(filterSwitch)

            let filterLabel = UILabel()
            filterLabel.text = filter
            stackViewVertical.addArrangedSubview(filterLabel)

            if currentApplicatedFilters.contains(where: { currentFilter in
                currentFilter.0 == filter && currentFilter.1 == filterType
            }) {
                filterSwitch.isOn = true
            }

            stackViewVertical.addArrangedSubview(UIView())

            stackView.addArrangedSubview(stackViewVertical)

            filtersState.append((filter,
                                 filterType,
                                 filterSwitch))
        }

        let subviewCount = stackView.subviews.count
        stackViewHeight.constant = CGFloat((subviewCount * 31) + (subviewCount - 1 > 0 ? (subviewCount - 1) * 5 : 0))
    }
}
