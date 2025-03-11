//
//  Siwf.swift
//
//
//  Created by Claire Olmstead on 2/12/25.
//

import SwiftUI
import SafariServices

public class Siwf: ObservableObject {
    public static func createSignInButton(mode: SiwfButtonMode = .primary, authData: GenerateAuthData) -> SiwfButton {
        let authUrl = generateAuthenticationUrl(authData: authData)
        
        return SiwfButton(
            mode: mode,
            authUrl: authUrl
        )
    }
}
