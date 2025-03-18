//
//  Siwf.swift
//
//
//  Created by Claire Olmstead on 2/12/25.
//

import SwiftUI
import SafariServices

/**
 * Object containing helper functions for Sign-In With Frequency (SIWF) authentication.
 */
public class Siwf: ObservableObject {
    // Singleton to support closing the button when the redirect happens
    public static let shared = Siwf()
    @Published var safariViewActive = false

    /**
     * Creates a sign-in button that initiates the authentication process.
     *
     * @param mode - The visual style of the button (Primary, Dark, Light).
     * @param authRequest - The authentication request containing signed request data and options.
     */
    public static func createSignInButton(mode: SiwfButtonMode = .primary, authRequest: GenerateAuthRequest) -> SiwfButton {
        let authUrl = generateAuthUrl(authRequest: authRequest)
        
        return SiwfButton(
            mode: mode,
            authUrl: authUrl
        )
    }

    /**
     * Handles authentication redirects by extracting the authorization code from the incoming URL.
     *
     *This function verifies that the incoming URL matches the expected redirect URL, extracts the
     * "authorizationCode" query parameter, and then processes it using the provided callback.
     * It also disables the active Safari view once authentication is complete.
     *
     * @param incomingUrl - The URL received after authentication.
     * @param redirectUrl - The expected redirect URL registered by the app.
     * @param processAuthorization - A closure that handles the extracted authorization code.
     */
    public static func handleRedirectUrl(incomingUrl: URL, redirectUrl: URL, processAuthorization: (_ authorizationCode: String) -> Void) -> Void {
        // No active safari view? Cannot be us
        if !shared.safariViewActive {
            return
        }
        guard let incomingUrl = URLComponents(url: incomingUrl, resolvingAgainstBaseURL: false),
              let authorizationCode = incomingUrl.queryItems?.first(where: { $0.name == "authorizationCode" })?.value else { return };

        let redirect = URLComponents(url: redirectUrl, resolvingAgainstBaseURL: false)

        // Make sure these match or we'll skip
        if incomingUrl.scheme != redirect?.scheme && incomingUrl.path != redirect?.path {
            return
        }
        
        debugPrint("Captured authorizationCode: \(authorizationCode)")
        // Trigger the closing of any button's SafariView
        shared.safariViewActive = false
        // TODO: Do we want to swap the authorizationCode for the full payload?
        // Trigger the callback
        processAuthorization(authorizationCode)
    }
}
