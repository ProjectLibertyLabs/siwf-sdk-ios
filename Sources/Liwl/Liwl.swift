//
//  LiwlSDK.swift
//
//
//  Created by Claire Olmstead on 2/12/25.
//

import SwiftUI
import SafariServices
import Models
import Helpers

public class Liwl: ObservableObject {
    public static func createSignInButton(handleAction: @escaping () -> Void, mode: LiwlButtonMode, authData: GenerateAuthData) -> LiwlButton {
        let authUrl = generateAuthenticationUrl(authData: authData)
        
        return LiwlButton(
            mode: mode,
            authUrl: authUrl,
            handleAction: handleAction
        )
    }
}
