//
//  SiwfAuthRequest.swift
//  Siwf
//
//  Created by Claire Olmstead on 3/14/25.
//

/**
 * Represents an authentication request.
 */
public struct GenerateAuthRequest {
    public let signedRequest: SignedRequest
    public let additionalCallbackUrlParams: [String: String]?
    public let options: Options?
    
    public init(signedRequest: SignedRequest, additionalCallbackUrlParams: [String: String]?, options: Options?) {
        self.signedRequest = signedRequest
        self.additionalCallbackUrlParams = additionalCallbackUrlParams
        self.options = options
    }
}

/**
 * Represents the different types of signed requests.
 */
public enum SignedRequest {
    case siwfEncodedSignedRequest(encodedSignedRequest: String)
    case siwfSignedRequest(requestedSignatures: SiwfRequestedSignature, requestedCredentials: [SiwfRequestedCredential] = [])
}

/**
 * Options for configuring authentication requests.
 */
public struct Options {
    public var endpoint: String
    
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
}

