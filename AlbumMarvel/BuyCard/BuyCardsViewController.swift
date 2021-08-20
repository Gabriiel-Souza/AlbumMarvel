//
//  BuyCardsViewController.swift
//  AlbumMarvel
//
//  Created by Gabriel Souza de Araujo on 19/08/21.
//

import UIKit

class BuyCardsViewController: UIViewController {

    @IBOutlet var mysteryCard: UIImageView!
    @IBOutlet var titleBackground: UIView!
    @IBOutlet var characterNameLbl: UILabel!
    @IBAction func getCardButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if let characters = cardCharacters {
            let randCardNumber = Int.random(in: 0...(characters.count - 1))
            let sortedCharacter = characters[randCardNumber]
            let actualCardsNumber:Int
            
            if var collected = cardsCollected {
                if var value = collected[sortedCharacter.name] {
                    value += 1
                    actualCardsNumber = value
                } else {
                    actualCardsNumber = 0
                }
                collected[sortedCharacter.name] = actualCardsNumber
                defaults.setValue(collected, forKey: "cardsCollected")
            } else {
                let initialDict = [sortedCharacter.name : 1]
                cardsCollected = initialDict
                defaults.setValue(initialDict, forKey: "cardsCollected")
            }
            
            if let image = cardImages[sortedCharacter.name] {
                self.mysteryCard.image = image.normalCard
                cardImages[sortedCharacter.name]?.grayCard = nil
                let notificationName = NSNotification.Name(rawValue: changeImageCollorNotification)
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
            self.characterNameLbl.text = sortedCharacter.name
            self.titleBackground.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
