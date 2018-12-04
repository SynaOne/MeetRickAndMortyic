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

    // MARK: - Private var
    private var datasAreLoaded = false
    private var characterResponse: CharacterResponse?
    private var characters: [Character] {
        if let characters = characterResponse?.results {
            return characters
        } else {
            return [Character]()
        }
    }
    private let cellSpacingHeight: CGFloat = 10
    private var isSortApply = false

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        characterTV.rowHeight = UITableView.automaticDimension

        loadDatas()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

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
        loadingLabel.text = "Chargement en cours..."
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
                strongSelf.loadingLabel.text = "Chargement impossible.\nVeuillez réessayer plus tard."
                strongSelf.reessayerButton.isHidden = false
            }

        }
    }

    func loadMoreDatas() {

        if let urlToCall = characterResponse?.info.next {
            ApiService.sharedApiService.getCharacters(urlToCall: urlToCall) { [weak self] characterResponse in

                guard let strongSelf = self else { return }

                if let characters = characterResponse.value,
                    characters.results.count > 0 {

                    strongSelf.characterResponse?.setResults(newResults: characters.results)
                    strongSelf.characterResponse?.setNewInfo(infos: characters.info)

                    if strongSelf.isSortApply {
                        strongSelf.applySort(PickerSortEnum.allCases[strongSelf.sortPicker.selectedRow(inComponent: 0)])
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
        characterTV.reloadData()

        isSortApply = true
    }
}

extension CharacterListeVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.section == characters.count - 1 {
            
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

        return characters.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = characterTV.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)

        guard let characterCell = cell as? CharacterCell,
            indexPath.section < characters.count
            else {
                return UITableViewCell()
        }

        if characters.indices.contains(indexPath.section) {
            characterCell.setup(character: characters[indexPath.section])
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
