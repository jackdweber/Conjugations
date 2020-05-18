//
//  Translate.swift
//  Conjugations
//
//  Created by Jack Weber on 5/2/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit

class Translate: NSObject {
    
    // Code used found in azure examples github
    // https://github.com/MicrosoftTranslator/Text-Translation-API-App-V3-IOS

    static func translate(phrase: String, linguas: String, completion: @escaping (_ status: Bool, _ result: String) -> Void) {
        let azureKey = "cc8405bdf183479dbe2ac0f61aadf5da"
            
        let contentType = "application/json"
        let traceID = UUID().uuidString
        print("Creating request with trace \(traceID)")
        //let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=en&to=es"
        let apiURL = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&" + linguas
        
        struct encodeText: Codable {
            var text = String()
        }
        
        let text2Translate = phrase
        let jsonEncoder = JSONEncoder()
        var encodeTextSingle = encodeText()
        var toTranslate = [encodeText]()
        
        encodeTextSingle.text = text2Translate
        toTranslate.append(encodeTextSingle)
        
        let jsonToTranslate = try? jsonEncoder.encode(toTranslate)
        let url = URL(string: apiURL)
        var request = URLRequest(url: url!)

        request.httpMethod = "POST"
        request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("AustraliaEast", forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
        request.addValue(String(describing: jsonToTranslate?.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonToTranslate
        
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            
            if responseError != nil {
                print("this is the error ", responseError!)
                completion(false, "Could not connect to service")
            }
            print("*****")
            parseJson(jsonData: responseData!, completion: completion)
        }
        task.resume()
    }
    
    static func parseJson(jsonData: Data, completion: @escaping (_ status: Bool, _ result: String) -> Void) {
        
        //*****TRANSLATION RETURNED DATA*****
        struct ReturnedJson: Codable {
            var translations: [TranslatedStrings]
        }
        struct TranslatedStrings: Codable {
            var text: String
            var to: String
        }
        
        let jsonDecoder = JSONDecoder()
        if let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: jsonData){
            let numberOfTranslations = langTranslations.count - 1
            print(langTranslations.count)
            completion(true, langTranslations[0].translations[numberOfTranslations].text)
        } else {
            completion(false, "Translate: Got nothing")
        }
    }
}
