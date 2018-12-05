//
//  CharacterListeVC.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 01/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import UIKit

@objcMembers
class CharacterListeVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var characterTV: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var reessayerButton: UIButton!
    @IBOutlet weak var sortPicker: UIPickerView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var charactersCount: UIBarButtonItem!

    // MARK: - Private var
    private var datasAreLoaded = false
    private var characterResponse: CharacterResponse?
    private let cellSpacingHeight: CGFloat = 10
    private var isSortActivated = false
    private var charactersFiltered: [Character] {
        var charactersFilterdOutput = [Character]()

        for character in characters {

            character.setAsToBoDisplayed(filters: currentApplicatedFilters)

            if character.asToBeDisplayed {
                charactersFilterdOutput.append(character)
            }
        }

        return charactersFilterdOutput
    }

    var currentApplicatedFilters = [(String, FiltersEnum)]() {
        didSet {
            filterButton.title = "Filters\(currentApplicatedFilters.count > 0 ? " ✔" : "")"
            characterTV.scrollToRow(at: IndexPath(row: 0, section: 0),
                                    at: .top,
                                    animated: true)
        }
    }
    var characters: [Character] {
        if let characters = characterResponse?.results {
            return characters
        } else {
            return [Character]()
        }
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        characterTV.rowHeight = UITableView.automaticDimension

        loadDatas()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        characterTV.reloadData()

        NotificationCenter.default.addObserver(self,

                                               selector: #selector(onNotifImageLoaded),
                                               name: .imageLoaded,
                                               object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - IBAction

    @IBAction func reessayerButtonClicked(_ sender: UIButton) {

        loadDatas()
    }

    @IBAction func sortButtonClicked(_ sender: UIBarButtonItem) {
        sortPicker.isHidden = false
    }
    
    // MARK: - Public func

    func onNotifImageLoaded(_ notification: NSNotification) {

        if let characterId = notification.userInfo?["characterId"] as? Int,
            let indexPaths = characterTV.indexPathsForVisibleRows {

            for indexPath in indexPaths {
                if (characterTV.cellForRow(at: indexPath) as? CharacterCell)?.character?.id == characterId {
                    characterTV.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }

    func loadDatas() {

        characterTV.isHidden = true
        activityIndicator.startAnimating()
        loadingLabel.text = "Loading..."
        reessayerButton.isHidden = true
        loadingView.isHidden = false

        ApiService.sharedApiService.getCharacters { [weak self] characterResponse in

            guard let strongSelf = self else { return }

            if let characters = characterResponse.value {
                strongSelf.characterResponse = characters

                if characters.results.count > 0 {
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.loadingView.isHidden = true
                    strongSelf.characterTV.isHidden = false
                }

                strongSelf.characterTV.reloadData()
            } else {

                strongSelf.activityIndicator.stopAnimating()
                strongSelf.activityIndicator.isHidden = true
                strongSelf.loadingLabel.text = "Loading failed.\nPlease retry later."
                strongSelf.reessayerButton.isHidden = false
            }

        }
    }

    func loadMoreDatas() {

        if let characterResponse = characterResponse,
            characterResponse.asMoreCharactersToLoad {

            let urlToCall = characterResponse.info.next
            ApiService.sharedApiService.getCharacters(urlToCall: urlToCall) { [weak self] characterResponse in

                guard let strongSelf = self else { return }

                if let characters = characterResponse.value,
                    characters.results.count > 0 {

                    strongSelf.characterResponse?.setResults(newResults: characters.results)
                    strongSelf.characterResponse?.setNewInfo(infos: characters.info)

                    if strongSelf.isSortActivated {
                        strongSelf.sortButton.title = "Sort"
                        strongSelf.showToast(message: "Sort desactivated.\nReason: New characters loaded.")
                        strongSelf.isSortActivated = false
                    }

                    strongSelf.characterTV.reloadData()

                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "CharacterDetails",
            let cellCharacter = (sender as? CharacterCell)?.character,
            let destinationVC = segue.destination as? CharacterDetailsVC {

            destinationVC.character = cellCharacter
            destinationVC.title = cellCharacter.name
        } else if segue.identifier == "FilterSelection",
            let destinationVC = segue.destination as? FilterSelectionVC {

            sortPicker.isHidden = true
            destinationVC.characterListe = characters
            destinationVC.currentApplicatedFilters = currentApplicatedFilters
        }
    }

    // MARK: - Private func
    private func applySort(_ sort: PickerSortEnum) {

        switch sort {
        case .genderAlpha:
            characterResponse?.results.sort(by: { (first, second) in
                first.gender.rawValue < second.gender.rawValue
            })
        case .genderAlphaInverse:
            characterResponse?.results.sort(by: { (first, second) in
                first.gender.rawValue > second.gender.rawValue
            })
        case .nameAlpha:
            characterResponse?.results.sort(by: { (first, second) in
                first.name < second.name
            })
        case .nameAlphaInverse:
            characterResponse?.results.sort(by: { (first, second) in
                first.name > second.name
            })
        case .noSort:
            break
        case .speciesAlpha:
            characterResponse?.results.sort(by: { (first, second) in
                first.species < second.species
            })
        case .speciesAlphaInverse:
            characterResponse?.results.sort(by: { (first, second) in
                first.species > second.species
            })
        case .statusAlpha:
            characterResponse?.results.sort(by: { (first, second) in
                first.status.rawValue < second.status.rawValue
            })
        case .statusAlphaInverse:
            characterResponse?.results.sort(by: { (first, second) in
                first.status.rawValue > second.status.rawValue
            })
        }

        isSortActivated = true

        characterTV.reloadData()

        sortButton.title = "Sort ✔"
    }
}

extension CharacterListeVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.section == charactersFiltered.count - 1 {
            
            view.setNeedsLayout()
            if characterResponse?.info.next != nil {
                loadMoreDatas()
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        if !sortPicker.isHidden {

            UIView.transition(with: sortPicker,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.sortPicker.alpha = 0
                              }, completion: { finished in
                                self.sortPicker.isHidden = true
                                self.sortPicker.alpha = 1
                              })
        }
    }
}

extension CharacterListeVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        charactersCount.title = "\(charactersFiltered.count) chars"
        return charactersFiltered.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = characterTV.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)

        guard let characterCell = cell as? CharacterCell,
            indexPath.section < charactersFiltered.count
            else {
                return UITableViewCell()
        }

        if charactersFiltered.indices.contains(indexPath.section) {
            characterCell.setup(character: charactersFiltered[indexPath.section])
        }
        return characterCell
    }
    
}

extension CharacterListeVC: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if PickerSortEnum.allCases.indices.contains(row) {
            return PickerSortEnum.allCases[row].rawValue
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if PickerSortEnum.allCases.indices.contains(row) {

            pickerView.isHidden = true

            applySort(PickerSortEnum.allCases[row])

        }
    }
}

extension CharacterListeVC: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerSortEnum.allCases.count
    }
    

    
}
