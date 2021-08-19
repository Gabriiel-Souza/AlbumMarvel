//
//  APIKeys.swift
//  AlbumMarvel
//
//  Created by Gabriel Souza de Araujo on 18/08/21.
//

import UIKit
import CryptoKit

let privateKey = "70e74c7e6738689bfd1e705e1d7076a6cd090259"
let publicKey = "1f365c5f372e1256346fa85e42271353"

fileprivate var aView: UIView?

//MARK: - Activity Indicator
extension UIViewController {
    
    func showSpinner () {
        aView = UIView(frame: self.view.frame)
        aView?.backgroundColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5725490196, alpha: 0.7759001271)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner () {
        
        aView?.removeFromSuperview()
        aView = nil
    }
}

//MARK: - Marvel's API Request
var fetchedCharacter: [Character]? = nil
var fetchedImages: [String : CardImage] = [:]
var cardsCollected: [String:Any]?
extension UIViewController {
        
    func searchCharacter (thenPresent finalVC: UIViewController?) {        
        
        // A long string which can change on a request-by-request basis
        let ts = String(Date().timeIntervalSince1970)
        //A md5 digest of the ts+privateKey+publicKey
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        //URL for get API info - Documentation can be found in https://developer.marvel.com/documentation/authorization
        let url = "http://gateway.marvel.com/v1/public/characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        print(url)
        let urlRequest = URLRequest(url: URL(string: url)!)
        //Create task to receive data from API
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, error) in
            guard let APIData = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error from [AlbumViewController] -> URLSession.dataTask")
                return
            }
            
            do {
                //Tells to Swift with class will receiva data and what is the data
                var characters = try JSONDecoder().decode(APIResult.self, from: APIData)
                // Tells to main thread execute this block
                
                if fetchedCharacter == nil {
                    //Remove character with image not available
                    characters.data.results.removeAll(where: { $0.thumbnail["path"] == "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
                    })
                    fetchedCharacter = characters.data.results
                }
                
                if let characters = fetchedCharacter {
                    if !characters.isEmpty { //Received at least 1 result
                        characters.forEach{ character in
                            
                            guard let imageData = try? Data(contentsOf: self!.getImageURL(data: character.thumbnail)) else {
                                fatalError("Data doesn't exist")
                            }
                            if var image = UIImage(data: imageData) {
                                if !self!.userHasCard(characterName: character.name) {
                                    if fetchedImages[character.name] == nil {
                                        if !self!.userHasCard(characterName: character.name) {
                                            guard let grayImage = self!.grayFilter(image: image) else {
                                                fatalError("Failed to apply filter in image \(image)")
                                            }
                                            image = grayImage
                                        }
                                        let cardImage = CardImage(image: image, isGray: true)
                                        fetchedImages[character.name] = cardImage
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            
            if let finalVC = finalVC {
                DispatchQueue.main.async {
                    self!.present(finalVC, animated: true, completion: nil)
                }
            }
            
        }.resume()
    }
    //MARK: - Hash Method
    func MD5 (data: String) -> String {
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func getImageURL(data: [String: String]) -> URL {
        
        let path = data["path"] ?? ""
        let extens = data["extension"] ?? ""
        let url = URL(string: "\(path).\(extens)")!
        print("Image url: \(url)")
        
        return url
    }
    
    func userHasCard(characterName name: String) -> Bool{
        
        if let cards = cardsCollected {
            if cards[name] != nil {
                return true
            }
        }
        return false
    }
    
    func grayFilter (image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        let filterName = "CIPhotoEffectTonal"
        if let filter = CIFilter(name: filterName) {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        } else {
            fatalError("Filter \"\(filterName)\" not encountered")
        }
        return nil
    }
}

let funnySentences = ["Punching Thanos in the face", "Licking a gem of infinity", "Entering the multiverse", "Being tricked by Loki", "I am Groot!"]
