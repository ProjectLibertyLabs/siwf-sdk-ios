//
//  DecodeAssets.swift
//  Siwf
//
//  Created by Claire Olmstead on 3/14/25.
//

import Foundation
import SwiftUI

/// Decodes a Base64-encoded image string into a `UIImage`.
///
/// - Parameter base64String: The Base64-encoded image string.
/// - Returns: The decoded `UIImage`, or `nil` if decoding fails.
public func decodeBase64Image(base64String: String?) -> UIImage? {
    guard let base64String = base64String, !base64String.isEmpty else {
        print("⚠️ Base64 string is empty or nil.")
        return nil
    }

    guard let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
        print("❌ Error: Unable to decode Base64 string into data.")
        return nil
    }

    guard let image = UIImage(data: imageData) else {
        print("❌ Error: Unable to create UIImage from data.")
        return nil
    }

    return image
}
