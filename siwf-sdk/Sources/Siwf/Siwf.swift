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

    public static func handleRedirectUrl(incomingUrl: URL, redirectUrl: URL, processAuthorization: (_ authorizationCode: String) -> Void) -> Void {
        // No active safari view? Cannot be us
        if !shared.safariViewActive {
            return
        }
        guard let incomingUrl = URLComponents(url: incomingUrl, resolvingAgainstBaseURL: false),
              let authCode = incomingUrl.queryItems?.first(where: { $0.name == "authorizationCode" })?.value else { return };

        let redirect = URLComponents(url: redirectUrl, resolvingAgainstBaseURL: false)

        // Make sure these match or we'll skip
        if incomingUrl.scheme != redirect?.scheme && incomingUrl.path != redirect?.path {
            return
        }
        
        debugPrint("Captured authorizationCode: \(authCode)")
        // Trigger the closing of any button's SafariView
        shared.safariViewActive = false
        // TODO: Do we want to swap the authorizationCode for the full payload?
        // Trigger the callback
        processAuthorization(authCode)
    }
}
