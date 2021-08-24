//
//  AlbumViewController.swift
//  AlbumMarvel
//
//  Created by Gabriel Souza de Araujo on 17/08/21.
//

import UIKit
import CryptoKit
import WebKit



class AlbumViewController: UIViewController, UICollectionViewDelegate {
    let cellId = "CardCell"
    @IBOutlet var collectionView: UICollectionView!
    var characterSelected:Character!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationName = NSNotification.Name(rawValue: changeImageCollorNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCollectionData), name: notificationName, object: nil)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        // Create the Refresh control when user push the top of screen
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self,
                                                      action: #selector(didPullToRefresh),
                                                      for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        // Re-fetch data
        self.searchCharacter(thenPresent: nil)
        self.refreshCollectionData()
    }
    
    @objc func refreshCollectionData () {
        DispatchQueue.main.async {
            print("Refreshing...")
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    //MARK: - Collection Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardCharacters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? CardCell else {
            fatalError("CardCell doesn't exist")
        }
        guard let character = cardCharacters?[indexPath.row] else {
            fatalError("Character doesn't exist")
        }
        
        let name = character.name
        
        var isGray:Bool = true
        if let imageDict = cardImages[name] {
            let image:UIImage
            if let grayCard = imageDict.grayCard {
                image = grayCard
            } else {
                image = imageDict.normalCard
                isGray = false
            }
            cell.setup(with: Card(heroImage: image, heroName: name, characterInfos: character, isGray: isGray))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CardCell {
            if !cell.isGray {
                self.showHero(cell.characterInfos)
            }
        }
    }
    //MARK: - Flow Layout Delegate Methods
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (self.view.frame.width - (3 * 20)) / 2
//
//        return CGSize(width: width, height: 200)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 20)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 20
//    }
    
    func showHero(_ character: Character) {
        self.characterSelected = character
        let popup = UIStoryboard(name: "CharacterPopup", bundle: nil)
        let popupCharacter = popup.instantiateViewController(withIdentifier: "CharacterPopup") as! CharacterPopupViewController
        
        popupCharacter.masterVC = self
        self.present(popupCharacter, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
