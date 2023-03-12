//
//  APIService.swift
//  Art Generator
//
//  Created by Jacob Lavenant on 3/11/23.
//

import Foundation

class APIService {
    let baseURL = "https://api.openai.com/v1/images/"                   //base for all URL calls
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String      //retieves api key from bundle
    
    func fetchImages(with data: Data) async throws {                    //func contains parameter as data as Data type that is async and can throw an error
        guard let apiKey else { fatalError("Could not get APIKey")}         //guard check to make sure we get api key also will create fatal error on fail
        guard let url = URL(string: baseURL + "generations") else {            //guard check to make sure url + "generations" is generated
            fatalError("Error: Invalid URL")                            //
        }
        var request = URLRequest(url: url)          //if both guard lets are good we could thenn request url
        request.httpMethod = "POST"             //uses POST to request
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")           //adds API key to the header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")        //specify string authization
        request.httpBody = data
        let (data, response) = try await URLSession.shared.data(for: request)       //make a aync call to the URLSession
        guard (response as? HTTPURLResponse) != nil else {      //guard check on the response to see if its a http url response
            fatalError("Error: Data request error")
        }
        print(String(decoding: data, as: UTF8.self))        
    }
}
