//
//  SiwfApp.swift
//
//  Created by Claire Olmstead on 12/6/24.
//

import SwiftUI
import Siwf

@main
struct SiwfApp: App {
    @State private var showAlert = false
    @State private var authorizationCode: String = ""
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .navigationTitle("SIWF Demo App")
            }
            .onOpenURL { url in
                guard let redirectUrl = URL(string: "siwfdemoapp://login") else {
                    print("❌ Error: Invalid redirect URL.")
                    return
                }

                Siwf.handleRedirectUrl(
                    incomingUrl: url,
                    redirectUrl: redirectUrl,
                    processAuthorization: { code in
                        print("✅ Successfully extracted authorization code: \(code)")
                        authorizationCode = code
                        showAlert = true
                        // Process the authorizationCode by sending it it your backend servers
                        // See https://projectlibertylabs.github.io/siwf/v2/docs/Actions/Response.html
                    }
                )
            }
            .alert("Success!", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Received Authorization Code: \(authorizationCode)")
            }
        }
    }
}
