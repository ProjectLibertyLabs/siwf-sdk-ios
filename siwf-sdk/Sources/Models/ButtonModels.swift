//
//  ButtonModels.swift
//
//
//  Created by Claire Olmstead on 2/21/25.
//

import Foundation

public enum LiwlButtonMode {
    case primary
    case dark
    case light
}

public struct GenerateAuthData {
    public let signedRequest: SiwfSignedRequest
    public let additionalCallbackUrlParams: [String: String]
    public let options: SiwfOptions?
    
    public init(signedRequest: SiwfSignedRequest, additionalCallbackUrlParams: [String: String], options: SiwfOptions?) {
        self.signedRequest = signedRequest
        self.additionalCallbackUrlParams = additionalCallbackUrlParams
        self.options = options
    }
}
