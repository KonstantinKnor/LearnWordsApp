//
//  ViewController.swift
//  LearnWordsApp
//
//  Created by Константин Кнор on 28.04.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var translateSearchBar: UISearchBar!
    @IBOutlet weak var translationResultTeksField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        translateSearchBar.delegate = self
    
    }

    
}

extension ViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        translateSearchBar.resignFirstResponder()
        let url = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate")
        guard url != nil else { return print("Error creating url object") }
        var request = URLRequest(url: url!)
        let header = ["Authorization": "Bearer t1.9euelZqUl8eZjJzGlZKUkM6Zx8fLlO3rnpWakcuLnJPKmJDNk5PHz52cyJjl8_dlSVRs-e88HD1p_N3z9yV4UWz57zwcPWn8.alyQnnuGiFyN1NZLjynuYopS4mQo-alwTjOSE8tGqGWXVmG1ytVgvcyPM-3z-SkFFjRA1VbV_rviOaTOytD9Dg"]
            request.allHTTPHeaderFields = header
        print(translateSearchBar.text)
        let jsonObject = [
                    "sourceLanguageCode":"en",
                    "targetLanguageCode":"ru",
                    "texts": [translateSearchBar.text!],
                    "folderId": "b1gd87lkr7j8s0fffk0i"] as [String:Any]
        do{
        let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            request.httpBody = requestBody
        }
        catch{
            print("Error creating the data object from data")
        }
        request.httpMethod = "POST"
        
        
        let session = URLSession.shared
        var text :String?
        let dataTask = session.dataTask(with: request) { [weak self] (data, responce, error) in
            
            if error == nil && data != nil {
                do {
               let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
               
                                   if let translations = json["translations"] as? [AnyObject]{
                                      if let arrayTexts = translations[0] as? [String:AnyObject] {
                                           text = arrayTexts["text"] as? String
               
                                       }
                                  }
               
                                   DispatchQueue.main.async {
                                       if text != nil {
                                           self?.translationResultTeksField.text = text
                                       }
                                   }
               
                               }catch {
                                   print("Error parsing responce data")
               
                               }
            }
        }.resume()
        
    }
}

