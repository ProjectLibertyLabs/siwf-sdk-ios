//
//  Siwf.swift
//
//
//  Created by Claire Olmstead on 2/12/25.
//

import SwiftUI
import SafariServices

public class Siwf: ObservableObject {
    // Singleton to support closing the button when the redirect happens
    public static let shared = Siwf()
    @Published var safariViewActive = false
    
    public static func createSignInButton(mode: SiwfButtonMode = .primary, authData: GenerateAuthData) -> SiwfButton {
        let authUrl = generateAuthenticationUrl(authData: authData)
        
        return SiwfButton(
            mode: mode,
            authUrl: authUrl
        )
    }
    
    public static func handleRedirectUrl(redirectUrl: URL, url: URL) -> Void {
        // No active safari view? Cannot be us
        if !shared.safariViewActive {
            return
        }
        guard let incomingUrl = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let authCode = incomingUrl.queryItems?.first(where: { $0.name == "authorizationCode" })?.value else { return };

        let redirect = URLComponents(url: redirectUrl, resolvingAgainstBaseURL: false)
              
        if incomingUrl.scheme != redirect?.scheme && incomingUrl.path != redirect?.path {
            // Not a match, don't process
            return
        }
        
        print("Captured auth token: \(authCode)")
        // Trigger the closing of any button's SafariView
        shared.safariViewActive = false
    }
}
