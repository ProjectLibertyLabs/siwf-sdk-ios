//
//  Siwf.swift
//
//
//  Created by Claire Olmstead on 2/12/25.
//

import SwiftUI
import SafariServices
import Models
import Helpers

@_exported import Models

public class Siwf: ObservableObject {
    public static func createSignInButton(handleAction: @escaping () -> Void, mode: SiwfButtonMode, authData: GenerateAuthData) -> SiwfButton {
        let authUrl = generateAuthenticationUrl(authData: authData)
        
        return SiwfButton(
            mode: mode,
            authUrl: authUrl,
            handleAction: handleAction
        )
    }
}
