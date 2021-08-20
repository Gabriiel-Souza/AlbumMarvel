//
//  CharacterPopupViewController.swift
//  AlbumMarvel
//
//  Created by Gabriel Souza de Araujo on 20/08/21.
//

import UIKit

class CharacterPopupViewController: UIViewController {
    
    @IBOutlet var characterImage: UIImageView!
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterDescription: UITextView!
    @IBOutlet var textBackground: UIView!
    var masterVC: AlbumViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = self.getImageURL(data: self.masterVC.characterSelected.thumbnail, mode: .landscape_incredible)
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                self.characterImage.image = image
            }
        }
        self.textBackground.layer.cornerRadius = 13
        self.textBackground.layer.masksToBounds = true
        self.characterName.text = self.masterVC.characterSelected.name
        self.characterDescription.text = self.masterVC.characterSelected.description
        
    }
}
