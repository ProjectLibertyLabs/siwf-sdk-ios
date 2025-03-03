//
//  SiwfModels.swift
//
//
//  Created by Claire Olmstead on 2/10/25.
//

import Foundation

public struct SiwfPublicKey: Codable, Equatable {
    let encodedValue: String
    let encoding: String
    let format: String
    let type: String

    public init(encodedValue: String) {
        self.encodedValue = encodedValue
        self.encoding = "base58"
        self.format = "ss58"
        self.type = "Sr25519"
    }
}

public struct SiwfSignature: Codable, Equatable {
    let algo: String
    let encoding: String
    let encodedValue: String

    public init(encodedValue: String) {
        self.algo = "SR25519"
        self.encoding = "base16"
        self.encodedValue = encodedValue
    }
}

public struct SiwfPayload: Codable, Equatable {
    let callback: String
    let permissions: [Int]
    let userIdentifierAdminUrl: String?

    public init(callback: String, permissions: [Int], userIdentifierAdminUrl: String? = nil) {
        self.callback = callback
        self.permissions = permissions
        self.userIdentifierAdminUrl = userIdentifierAdminUrl
    }
}

public struct SiwfRequestedSignature: Codable, Equatable {
    let publicKey: SiwfPublicKey
    let signature: SiwfSignature
    let payload: SiwfPayload
    
    public init(publicKey: SiwfPublicKey, signature: SiwfSignature, payload: SiwfPayload) {
        self.publicKey = publicKey
        self.signature = signature
        self.payload = payload
    }
}

public struct AnyOfRequired: Codable, Equatable {
    let field: String // Example placeholder, update as necessary
}

public struct SiwfCredential: Codable, Equatable {
    let credentialId: String // Example placeholder, update as necessary
}

public enum SiwfCredentialRequest: Codable, Equatable {
    case anyOfRequired(AnyOfRequired)
    case siwfCredential(SiwfCredential)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let anyOfRequired = try? container.decode(AnyOfRequired.self) {
            self = .anyOfRequired(anyOfRequired)
        } else if let siwfCredential = try? container.decode(SiwfCredential.self) {
            self = .siwfCredential(siwfCredential)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid SiwfCredentialRequest type")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .anyOfRequired(let anyOfRequired):
            try container.encode(anyOfRequired)
        case .siwfCredential(let siwfCredential):
            try container.encode(siwfCredential)
        }
    }
}

public struct SiwfSignedRequest: Codable, Equatable {
    public let requestedSignatures: SiwfRequestedSignature
    public let requestedCredentials: [SiwfCredentialRequest]?

    public init(requestedSignatures: SiwfRequestedSignature, requestedCredentials: [SiwfCredentialRequest]? = nil) {
        self.requestedSignatures = requestedSignatures
        self.requestedCredentials = requestedCredentials
    }

    // Custom Equatable conformance
    public static func == (lhs: SiwfSignedRequest, rhs: SiwfSignedRequest) -> Bool {
        return lhs.requestedSignatures == rhs.requestedSignatures &&
               lhs.requestedCredentials == rhs.requestedCredentials
    }
}

public struct SiwfOptions {
    public var endpoint: String
    public var loginMsgUri: String?
}
