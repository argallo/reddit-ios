//
//  WebService.swift
//  reddit
//
//  Created by Anthony Gallo on 3/19/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation

protocol Models {
    associatedtype modelType
}

/* Our web request service */
class WebService {
    /* Generic URL Request that will be mapped into a codable object */
    func makeRequest<T: Decodable>(with urlString: String, into modelClass: T.Type, completion: @escaping (Decodable?) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Error: urlString could not be created as URL")
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let datatask = session.dataTask(with: request) { [weak self] (data, response, error) in
            
            //quick error checks
            guard error == nil else {
                print("Network error: \(String(describing: error))")
                return
            }
            guard let responseData = data else {
                print("Error: response data nil")
                return
            }
            guard let strongSelf = self else {
                print("Error: self was nil")
                return
            }
            completion(strongSelf.injectIntoModel(responseData, modelClass))
        }
        datatask.resume()
    }
    
    /* We map our response into its model which can be any model that extends Decodable */
    private func injectIntoModel<T : Decodable>(_ data: Data, _ model: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let mappedModel: T = try decoder.decode(model, from: data)
            return mappedModel
        } catch let jsonError {
            print("Error parsing JSON: \(jsonError)")
            return nil
        }
    }
    
}
