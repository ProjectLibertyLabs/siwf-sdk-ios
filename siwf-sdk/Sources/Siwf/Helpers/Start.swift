//
//  Start.swift
//
//
//  Created by Claire Olmstead on 2/10/25.
//

import Foundation
import Models

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

public func generateAuthenticationUrl(authData: GenerateAuthData) -> URL {
    let encodedSignedRequest = switch authData.signedRequest {
        case .siwfEncodedSignedRequest(let siwfEncodedSignedRequest): siwfEncodedSignedRequest
        case .siwfSignedRequest(let siwfSignedRequest): encodeSignedRequest(SiwfSignedRequest(requestedSignatures: siwfSignedRequest.signature, requestedCredentials: siwfSignedRequest.credentials))
    }

    let endpoint = parseEndpoint(input: authData.options?.endpoint ?? "mainnet", path: EndpointPath.start)
    
    guard var urlComponents = URLComponents(string: endpoint) else {
        fatalError("Failed to correctly parse endpoint")
    }

    // Filter out reserved query parameters
    let queryItems = authData.additionalCallbackUrlParams?.compactMap {
        $0.key != "signedRequest" && $0.key != "authorizationCode" ? URLQueryItem(name: $0.key, value: $0.value) : nil
    } ?? []

    // Append the signed request last
    urlComponents.queryItems = queryItems + [URLQueryItem(name: "signedRequest", value: encodedSignedRequest)]

    guard var url = urlComponents.url else {
            fatalError("Failed to correctly parse endpoint")
        }

    return url
}
