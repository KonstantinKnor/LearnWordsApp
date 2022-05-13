

import UIKit


let lan = ChooseLanguade.init(sourceLanguageCode: "", targetLanguageCode: "")

class ViewController: UIViewController {

    @IBOutlet weak var languageSenderOutlet: UISegmentedControl!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var translateSearchBar: UISearchBar!
    @IBOutlet weak var translationResultTeksField: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translateSearchBar.delegate = self
        addButtonOutlet.layer.cornerRadius = 10
        lan.sourceLanguageCode = "en"
        lan.targetLanguageCode = "ru"
    }


    @IBAction func languageSenderAction(_ sender: Any) {
      
        switch languageSenderOutlet.selectedSegmentIndex {
        case 0:
            lan.sourceLanguageCode = "en"
            lan.targetLanguageCode = "ru"
        case 1:
            lan.sourceLanguageCode = "ru"
            lan.targetLanguageCode = "en"
        default: break
        }
      
    }
    @IBAction func addButtonAction(_ sender: Any) {
        
    }
    
}

extension ViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        translateSearchBar.resignFirstResponder()
        let url = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate")
        guard url != nil else { return print("Error creating url object") }
        var request = URLRequest(url: url!)
        let header = ["Authorization": "Bearer t1.9euelZqLyMiLiZqajszInMeJlc-Xl-3rnpWakcuLnJPKmJDNk5PHz52cyJjl8_dJPQds-e8ML1s3_d3z9wlsBGz57wwvWzf9.WplBTcWFPv4h71_gQpjPdJV_B7C1SDr5vJTKUdaSTexERkJArlherrQJ-XxDBdae410l-Pdnm7G0PI4J4P2HDw"]
            request.allHTTPHeaderFields = header
        print(translateSearchBar.text)
       print(lan.sourceLanguageCode,lan.targetLanguageCode)
        let jsonObject = [
                        "sourceLanguageCode":"\(lan.sourceLanguageCode)",
                        "targetLanguageCode":"\(lan.targetLanguageCode)",
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
        print("hello")
        
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

