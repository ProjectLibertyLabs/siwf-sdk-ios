//
//  Assets.swift
//
//
//  Created by Claire Olmstead on 2/21/25.
//

import Foundation

public struct Assets: Codable {
    public let colors: Colors
    public let content: Content
    public let images: Images
}

public struct Colors: Codable {
    public let primary: String
    public let light: String
    public let dark: String
}

public struct Content: Codable {
    public let title: String
}

public struct Images: Codable {
    public let logoPrimary: String
    public let logoLight: String
    public let logoDark: String
}

public func fetchAssets(completion: @escaping (Assets?) -> Void) {
    let urlString = "https://projectlibertylabs.github.io/siwf/v2/assets/assets.json"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching data: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let assets = try decoder.decode(Assets.self, from: data)
            DispatchQueue.main.async {
                completion(assets)
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }.resume()
}
