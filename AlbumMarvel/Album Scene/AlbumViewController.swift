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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    //MARK: - Collection Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedCharacter?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? CardCell else {
            fatalError("CardCell doesn't exist")
        }
        guard let name = fetchedCharacter?[indexPath.row].name else {
            fatalError("Name doesn't exist")
        }
        
        if let image = fetchedImages[name] {
            cell.setup(with: Card(heroImage: image, heroName: name))
        }
        
        return cell
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
}
