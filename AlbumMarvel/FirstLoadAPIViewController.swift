//
//  LaunchScreenViewController.swift
//  AlbumMarvel
//
//  Created by Gabriel Souza de Araujo on 18/08/21.
//

import UIKit

class FirstLoadAPIViewController: UIViewController {
    var canRefresh:Bool = false
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var funnyLoadingLabel: UILabel!
    
    override func viewDidLoad() {
        self.funnyLoadingLabel.text = funnySentences[0]
        //Change sentence
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.funnyLoadingLabel.text = funnySentences.randomElement()
        }
        
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        self.searchCharacter(thenPresent: mainVC)
    }    
}










