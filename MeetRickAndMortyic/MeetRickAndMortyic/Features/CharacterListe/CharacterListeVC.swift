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
