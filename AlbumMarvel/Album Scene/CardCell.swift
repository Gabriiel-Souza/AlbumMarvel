//
//  cardCell.swift
//  AlbumMarvel
//
//  Created by Gabriel Souza de Araujo on 18/08/21.
//

import UIKit

struct Card {
    var heroImage: CardImage
    var heroName: String
}

struct CardImage {
    var image:UIImage
    var isGray:Bool
}

class CardCell: UICollectionViewCell {
    
    @IBOutlet var heroImage: UIImageView!
    @IBOutlet var heroNameLbl: UILabel!
    
    func setup (with card: Card){
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.heroImage.image = card.heroImage.image
        self.heroNameLbl.text = card.heroName
    }
    

}
