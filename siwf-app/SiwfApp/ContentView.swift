//
//  ContentView.swift
//  SiwfApp
//
//  Created by Claire Olmstead on 12/6/24.
//

import SwiftUI
import Siwf

struct ContentView: View {
    let exampleRequest = SiwfSignedRequest(
        requestedSignatures: SiwfRequestedSignature(
            publicKey: SiwfPublicKey(encodedValue: "examplePublicKey"),
            signature: SiwfSignature(encodedValue: "exampleEncodedSignature"),
            payload: SiwfPayload(
                callback: "https://www.google.com",
                permissions: [1, 2, 3]
            )
        )
    )

    
    var authData: GenerateAuthData {
        GenerateAuthData(
            signedRequest: exampleRequest,
            additionalCallbackUrlParams: [:],
            options: nil
        )
    }

    
    func handleAction() -> Void {}
    
    var body: some View {
        Siwf.createSignInButton(handleAction: handleAction, mode: .primary, authData: authData)
        Siwf.createSignInButton(handleAction: handleAction, mode: .dark, authData: authData)
        Siwf.createSignInButton(handleAction: handleAction, mode: .light, authData: authData)
    }
}

#Preview {
    ContentView()
}
