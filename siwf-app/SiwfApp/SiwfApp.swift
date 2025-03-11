//
//  SiwfApp.swift
//
//  Created by Claire Olmstead on 12/6/24.
//

import SwiftUI
import Siwf

@main
struct SiwfApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .navigationTitle("SIWF Demo App")
            }
            
            .onOpenURL { url in
                Siwf.handleRedirectUrl(redirectUrl: URL(string: "siwfdemoapp://login")!, url: url)
            }
        }
    }
}

