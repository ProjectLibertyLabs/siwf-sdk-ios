//
//  File.swift
//  
//
//  Created by Claire Olmstead on 2/10/25.
//

import Foundation

struct SiwfPublicKey: Codable {
    let encodedValue: String
    let encoding: String
    let format: String
    let type: String

    init(encodedValue: String) {
        self.encodedValue = encodedValue
        self.encoding = "base58"
        self.format = "ss58"
        self.type = "Sr25519"
    }
}

struct SiwfSignature: Codable {
    let algo: String
    let encoding: String
    let encodedValue: String

    init(encodedValue: String) {
        self.algo = "SR25519"
        self.encoding = "base16"
        self.encodedValue = encodedValue
    }
}

struct SiwfPayload: Codable {
    let callback: String
    let permissions: [Int]
    let userIdentifierAdminUrl: String?

    init(callback: String, permissions: [Int], userIdentifierAdminUrl: String? = nil) {
        self.callback = callback
        self.permissions = permissions
        self.userIdentifierAdminUrl = userIdentifierAdminUrl
    }
}

struct SiwfRequestedSignature: Codable {
    let publicKey: SiwfPublicKey
    let signature: SiwfSignature
    let payload: SiwfPayload
}

struct AnyOfRequired: Codable {
    let field: String // Example placeholder, update as necessary
}

struct SiwfCredential: Codable {
    let credentialId: String // Example placeholder, update as necessary
}

enum SiwfCredentialRequest: Codable {
    case anyOfRequired(AnyOfRequired)
    case siwfCredential(SiwfCredential)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let anyOfRequired = try? container.decode(AnyOfRequired.self) {
            self = .anyOfRequired(anyOfRequired)
        } else if let siwfCredential = try? container.decode(SiwfCredential.self) {
            self = .siwfCredential(siwfCredential)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid SiwfCredentialRequest type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .anyOfRequired(let anyOfRequired):
            try container.encode(anyOfRequired)
        case .siwfCredential(let siwfCredential):
            try container.encode(siwfCredential)
        }
    }
}

struct SiwfSignedRequest: Codable {
    let requestedSignatures: SiwfRequestedSignature
    let requestedCredentials: [SiwfCredentialRequest]?

    init(requestedSignatures: SiwfRequestedSignature, requestedCredentials: [SiwfCredentialRequest]? = nil) {
        self.requestedSignatures = requestedSignatures
        self.requestedCredentials = requestedCredentials
    }
}
