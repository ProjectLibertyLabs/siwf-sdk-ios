//
//  File.swift
//  
//
//  Created by Claire Olmstead on 2/10/25.
//

import Foundation

enum SiwfEndpoint: String {
    case production = "https://production.example.com/start"
    case staging = "https://staging.example.com/start"
}

struct SiwfOptions {
    var endpoint: String
    var loginMsgUri: String?
}

func encodeSignedRequest(_ request: SiwfSignedRequest) -> String? {
    do {
        let jsonData = try JSONEncoder().encode(request)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        return stringToBase64URL(jsonString)
    } catch {
        print("Error encoding signed request: \(error)")
        return nil
    }
}

enum EndpointPath: String {
    case start = "/start"
    case apiPayload = "/api/payload"
}

func parseEndpoint(input: String, path: EndpointPath) -> String {
    switch input.lowercased() {
    case "mainnet", "production", "prod":
        return "https://www.frequencyaccess.com/siwa" + path.rawValue
    case "testnet", "staging":
        return "https://testnet.frequencyaccess.com/siwa" + path.rawValue
    default:
        return input.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + path.rawValue
    }
}

func generateAuthenticationUrl(
    signedRequest: SiwfSignedRequest,
    additionalCallbackUrlParams: [String: String],
    options: SiwfOptions?
) -> String? {
    let encodedSignedRequest = encodeSignedRequest(signedRequest)
    let endpoint = parseEndpoint(input: options?.endpoint ?? "mainnet", path: EndpointPath.start)
    
    guard var urlComponents = URLComponents(string: endpoint) else {
        return nil
    }
    
    var queryItems = additionalCallbackUrlParams.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    // Ensure the signed request is set last so it cannot be overridden
    queryItems.append(URLQueryItem(name: "signedRequest", value: encodedSignedRequest))
    
    // Remove reserved keywords if present
    queryItems = queryItems.filter { $0.name != "authorizationCode" }
    
    urlComponents.queryItems = queryItems
    
    return urlComponents.url?.absoluteString
}
