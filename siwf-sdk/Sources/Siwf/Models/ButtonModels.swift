//
//  ButtonModels.swift
//
//
//  Created by Claire Olmstead on 2/21/25.
//

import Foundation

public enum SiwfButtonMode {
    case primary
    case dark
    case light
}

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
