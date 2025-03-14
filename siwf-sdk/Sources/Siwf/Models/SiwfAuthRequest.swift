//
//  SiwfAuthRequest.swift
//  Siwf
//
//  Created by Claire Olmstead on 3/14/25.
//

public struct GenerateAuthData {
    public let signedRequest: SignedRequest
    public let additionalCallbackUrlParams: [String: String]?
    public let options: SiwfOptions?
    
    public init(signedRequest: SignedRequest, additionalCallbackUrlParams: [String: String]?, options: SiwfOptions?) {
        self.signedRequest = signedRequest
        self.additionalCallbackUrlParams = additionalCallbackUrlParams
        self.options = options
    }
}

public enum SignedRequest {
    case siwfEncodedSignedRequest(encodedSignedRequest: String)
    case siwfSignedRequest(signature: SiwfRequestedSignature, credentials: [SiwfRequestedCredential]? = [])
}

public struct SiwfOptions {
    public var endpoint: String
    
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
}

