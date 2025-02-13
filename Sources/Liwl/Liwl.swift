//
//  LiwlSDK.swift
//
//
//  Created by Claire Olmstead on 2/12/25.
//

import SwiftUI
import SafariServices

public class Liwl {
    @Published public var url: URL?
    @Published public var showSafariView: Bool = false
    
    public static let shared = Liwl()
    
    public static func createSignInButton(handleAction: @escaping () -> Void) -> LiwlButton {
            return LiwlButton(
                style: .normal, title: "Log In With Liberty",
                handleAction: handleAction,
                url: .constant(nil), 
                showSafariView: .constant(false)
            )
        }

    public func openLIWL(url: URL) {
        DispatchQueue.main.async {
            self.url = url
            self.showSafariView = true
        }
    }
    
    public static func onSignInComplete(_ callback: @escaping (Result<User, Error>) -> Void) {
        LiwlAuthManager.shared.signInCompletion = callback
    }
    
    public static func handleCallback(url: URL) -> Bool {
        return LiwlAuthManager.shared.handleSignInCallback(url: url)
    }
    
    @objc private static func signInTapped() {
        print("Sign-In Button!")
        LiwlAuthManager.shared.startSignInProcess()
    }
}
