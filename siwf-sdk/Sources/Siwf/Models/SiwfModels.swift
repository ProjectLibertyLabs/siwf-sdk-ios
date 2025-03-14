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

public enum SiwfRequestedCredential: Codable {
    case single(SingleCredential)
    case anyOf(AnyOfCredentials)

    private enum CodingKeys: String, CodingKey {
        case type
        case hash
        case anyOf
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let anyOf = try? container.decode([SingleCredential].self, forKey: .anyOf) {
            self = .anyOf(AnyOfCredentials(anyOf: anyOf))
        } else {
            let type = try container.decode(String.self, forKey: .type)
            let hash = try container.decode([String].self, forKey: .hash)
            self = .single(SingleCredential(type: type, hash: hash))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .single(let credential):
            try container.encode(credential.type, forKey: .type)
            try container.encode(credential.hash, forKey: .hash)
        case .anyOf(let credentials):
            try container.encode(credentials.anyOf, forKey: .anyOf)
        }
    }
}

public struct SingleCredential: Codable, Equatable {
    let type: String
    let hash: [String]
    
    public init(type: String, hash: [String]) {
        self.type = type
        self.hash = hash
    }
}

public struct AnyOfCredentials: Codable, Equatable {
    let anyOf: [SingleCredential]
    
    public init(anyOf: [SingleCredential]) {
        self.anyOf = anyOf
    }
}

public struct SiwfSignedRequest: Codable {
    public let requestedSignatures: SiwfRequestedSignature
    public let requestedCredentials: [SiwfRequestedCredential]?

    public init(requestedSignatures: SiwfRequestedSignature, requestedCredentials: [SiwfRequestedCredential]? = []) {
        self.requestedSignatures = requestedSignatures
        self.requestedCredentials = requestedCredentials
    }
}
