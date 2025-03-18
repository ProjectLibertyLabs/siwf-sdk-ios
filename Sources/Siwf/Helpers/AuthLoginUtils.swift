//
//  AuthLoginUtils.swift
//
//
//  Created by Claire Olmstead on 2/10/25.
//

import Foundation

enum AuthEndpoint: String {
    case start = "/start"
    case apiPayload = "/api/payload"
}

/**
 * Encodes a SIWF signed request into a Base64-encoded string.
 *
 * @param request The signed authentication request.
 * @return Base64 encoded string or null if an error occurs.
 */
func encodeSignedRequest(_ request: SiwfSignedRequest) -> String? {
    do {
        let jsonData = try JSONEncoder().encode(request)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        return stringToBase64URL(jsonString)
    } catch {
        print("❌ Error encoding signed request: \(error)")
        return nil
    }
}

/**
 * Determines the correct authentication endpoint based on the input environment.
 *
 * @param environment The environment name (e.g., "mainnet", "testnet").
 * @param endpoint The API path from [AuthEndpoint].
 * @return The full URL to the authentication endpoint.
 */
func resolveAuthEndpoint(environment: String, endpoint: AuthEndpoint) -> String {
    switch environment.lowercased() {
    case "mainnet", "production", "prod":
        return "https://www.frequencyaccess.com/siwa" + endpoint.rawValue
    case "testnet", "staging":
        return "https://testnet.frequencyaccess.com/siwa" + endpoint.rawValue
    default:
        print("⚠️ Using custom authentication endpoint")
        return environment.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + endpoint.rawValue
    }
}

/**
 * Generates an authentication URL with query parameters for a sign-in request.
 *
 * @param authRequest - The authentication request object containing details.
 * @return A Uri object representing the final authentication URL.
 * @throws Exception If encoding the signed request fails.
 */
public func generateAuthUrl(authRequest: GenerateAuthRequest) -> URL {
    let encodedSignedRequest = switch authRequest.signedRequest {
        case .siwfEncodedSignedRequest(let siwfEncodedSignedRequest): siwfEncodedSignedRequest
        case .siwfSignedRequest(let siwfSignedRequest): encodeSignedRequest(SiwfSignedRequest(requestedSignatures: siwfSignedRequest.requestedSignatures, requestedCredentials: siwfSignedRequest.requestedCredentials))
    }

    let authEndpoint = resolveAuthEndpoint(environment: authRequest.options?.endpoint ?? "mainnet", endpoint: AuthEndpoint.start)
    
    guard var urlComponents = URLComponents(string: authEndpoint) else {
        fatalError("❌ Failed to correctly parse endpoint")
    }

    // Filter out reserved query parameters
    let queryItems = authRequest.additionalCallbackUrlParams?.compactMap {
        $0.key != "signedRequest" && $0.key != "authorizationCode" ? URLQueryItem(name: $0.key, value: $0.value) : nil
    } ?? []

    // Append the signed request last
    urlComponents.queryItems = queryItems + [URLQueryItem(name: "signedRequest", value: encodedSignedRequest)]

    guard var finalUri = urlComponents.url else {
            fatalError("❌ Failed to correctly parse endpoint")
        }

    print("🔗 Generated authentication URL: \(finalUri)")
    return finalUri
}
